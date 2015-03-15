class User < ActiveRecord::Base
  rolify

  acts_as_follower
  acts_as_followable
  acts_as_voter

  acts_as_taggable_on :places

  # Include devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :token_authenticatable
  attr_writer :invitation_instructions
  attr_reader :raw_invitation_token
  has_many :invitations, class_name: self.to_s, as: :invited_by

  has_and_belongs_to_many :causes

  has_and_belongs_to_many :charities_as_editor, class_name: "Charity", join_table: :charities_editors
  has_and_belongs_to_many :charities_as_reporter, class_name: "Charity", join_table: :charities_reporters

  has_and_belongs_to_many :projects_as_reporter, class_name: "Project", join_table: :projects_reporters
  has_and_belongs_to_many :projects_as_editor, class_name: "Project", join_table: :editors_projects

  has_many :stripe_customers
  has_many :subscriptions
  has_many :donations
  has_many :project_donations
  has_many :achievements

  attr_accessible :role_ids
  attr_accessible :name, :first_name, :last_name, :email, :password, :password_confirmation, :current_password, :remember_me,
    :provider, :uid, :cause_ids, :place_list, :intelligent_matching, :invitation_limit
  attr_accessor :current_password

  before_save :ensure_authentication_token
  after_initialize :init

  attr_accessible :avatar
  has_attached_file :avatar,
                    styles: { square: "200x200#", small: "400x400>" },
                    path: "users/:id/avatar/:style/:filename",
                    default_url: '/assets/avatars/:style/missing.png'
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/jpg', 'image/png']

  validates :first_name, :last_name, presence: true
  validates :uid, uniqueness: true, allow_blank: true
  validates :email, presence: true, email: true

  def name
    "#{first_name} #{last_name}".strip.presence || read_attribute('name')
  end

  rails_admin do
    list do
      field :name
      field :email
      include_all_fields
    end
    edit do
      field :name
      field :email
      include_all_fields
    end
  end

  # Devise invitable
  def deliver_invitation
    if @invitation_instructions
      ::Devise.mailer.send(@invitation_instructions, self).deliver
    else
      super
    end
  end

  def self.mass_invite!(attributes={}, invited_by=nil)
    self.invite!(attributes, invited_by) do |invitable|
      invitable.invitation_instructions = :mass_invitation_instructions
    end
  end

  def self.waiting_list_invite!(attributes={}, invited_by=nil)
    self.invite!(attributes, invited_by) do |invitable|
      invitable.invitation_instructions = :waiting_list_invitation_instructions
    end
  end

  class << self
    def send_mass_invitations emails
      User.mass_invite!(email: emails.first)
      emails = emails.drop(1)
      User.send_mass_invitations(emails) unless emails.empty?
    end
    handle_asynchronously :send_mass_invitations, run_at: Proc.new { 1.minutes.from_now }
  end
  # .Devise invitable

  class << self
    def create_subscriptions_from_cart(cart, gift_aid_charity_ids, user)
      if gift_aid_charity_ids
        gift_aid_charity_ids = gift_aid_charity_ids.split(',').map {|i| i.to_i}
      else
        gift_aid_charity_ids = []
      end
      subsriptions_to_update_on_stripe = []

      cart.shopping_cart_items.each do |item|
        project = Project.find(item.item_id)

        subscription = Subscription.find_or_create_by_charity_id_and_user_id(project.charity.id, user.id)
        merchant_customer = Charity.get_merchant_customer(project.charity, user) # find or create
        unless subscription.interval
          subscription.interval = Settings.subscription_interval
          stripe_customer = StripeCustomer.find_by_charity_id_and_user_id(project.charity.id, user.id)
          subscription.stripe_customer = stripe_customer
          subscription.save
        end

        if merchant_customer
          amount = Money.new(item.price * 100, "GBP")
          subscription_project = SubscriptionProject.find_or_create_by_subscription_id_and_project_id(subscription.id, project.id)
          subscription_project.amount = amount
          subscription_project.gift_aid = gift_aid_charity_ids.include?(project.charity.id)
          subscription_project.save

          subsriptions_to_update_on_stripe << subscription
        end
      end
      cart.clear

      subsriptions_to_update_on_stripe.uniq.each do |subscription|
        subscription.update_stripe
      end
    end
    handle_asynchronously :create_subscriptions_from_cart
  end

  def stripe_customer
    self.stripe_customers.where("customer_id IS NOT NULL").first
  end

  def change_score
    self.change_stories.sum(&:number).to_i
  end

  # TODO: improve
  def suggested_project
    project = nil
    tries = 0
    while project.nil? && tries < 5
      project = Project.public.unfunded.offset(rand(Project.public.unfunded.count))[0]
      project = nil if SubscriptionProject.joins(:subscription).where('subscriptions.user_id' => self.id, project_id: project.id).any?
      tries += 1
    end
    project
  end

  def projects
    list = []
    subscriptions.each do |subscription|
      subscription.projects.each { |project| list << project }
    end
    list.uniq
  end

  def helped_projects
    list = []
    project_donations.paid.each do |donation|
      list << donation.project if donation.project.public?
    end
    list.uniq
  end

  def change_stories
    Story.find_all_by_project_id(helped_projects.map(&:id))
  end

  def charities
    charities_as_editor + charities_as_reporter
  end

  def projects_as_colleague
    projects_as_editor + projects_as_reporter
  end

  def inspired
    []
  end

  def stories
    []
  end

  def achievements_of_followings
    list = []
    self.follows_by_type('User').each do |following|
      following.followable.achievements.each { |achievement| list << achievement }
    end
    list
  end

  def self.find_for_facebook_token access_token
    begin
      graph   = Koala::Facebook::API.new(access_token)
      profile = graph.get_object("me")
    rescue Koala::Facebook::APIError => e
      return
    end
    return unless profile['email'].present?

    if user = User.where(provider: 'facebook', uid: profile['id']).first
      # Do nothing
    elsif user = User.where(email: profile['email']).first
      # user already registered, add facebook uid
      user.facebook_uid = profile['id']
    else
      user = User.new provider: 'facebook', uid: profile['id'],
        password: Devise.friendly_token[0,20]
      user.email = profile['email']
      user.name  = profile['name']
      user.first_name  = profile['first_name']
      user.last_name  = profile['last_name']
    end

    user.facebook_token = access_token

    user.save ? user : nil
  end

  def path
    Rails.application.routes.url_helpers.user_path(self)
  end

  extend FriendlyId
  friendly_id :name, use: :slugged

  def to_s
    "#{name} (#{email})"
  end

  protected
    def init
      self.intelligent_matching ||= false
    end
end
