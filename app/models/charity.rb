class Charity < ActiveRecord::Base
  acts_as_followable

  scope :public, -> { where(is_public: true) }
  scope :pending, -> { where("is_public = ? OR chv1_file_name IS NULL OR contract_file_name IS NULL OR paying_in_slip_file_name IS NULL OR hmrc_number IS NULL OR charity_regulator IS NULL", false) }

  belongs_to :leader, class_name: 'User', foreign_key: 'leader_id'
  has_many :projects
  has_and_belongs_to_many :reporters, :class_name=> "User", join_table: :charities_reporters, :after_add => :after_add_colleague
  has_and_belongs_to_many :editors, :class_name=> "User", join_table: :charities_editors, :after_add => :after_add_colleague

  has_one :go_cardless_merchant
  has_one :stripe_merchant

  has_many :stripe_customers
  has_many :subscriptions
  has_many :donations

  attr_accessible :logo
  has_attached_file :logo,
                    :styles => { square: "200x200#", small: "400x400>", profile: "240x175#" },
                    :path => "charities/:id/logo/:style/:filename",
                    :default_url => "/assets/charities/logo/:style/logo.png"
  validates_attachment_content_type :logo, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  attr_accessible :chv1
  has_attached_file :chv1, :path => "charities/:id/chv1/:filename"
  validates_attachment_content_type :chv1, :content_type => /\Aimage\/.*\Z|\Aapplication\/pdf\Z/

  attr_accessible :contract
  has_attached_file :contract, :path => "charities/:id/contract/:filename"
  validates_attachment_content_type :contract, :content_type => /\Aimage\/.*\Z|\Aapplication\/pdf\Z/

  attr_accessible :paying_in_slip
  has_attached_file :paying_in_slip, :path => "charities/:id/paying_in_slip/:filename"
  validates_attachment_content_type :paying_in_slip, :content_type => /\Aimage\/.*\Z|\Aapplication\/pdf\Z/

  attr_accessible :leader_id, :address, :description, :name, :number, :is_public, :hmrc_number, :charity_regulator, :landline_phone, :mobile_phone, :skype, :email, :office_address, :registered_charity_address, :notes
  attr_accessible :project_ids, :admin_ids, :reporter_ids, :editor_ids

  validates :name, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :number, presence: true
  if [:staging, :production].include? Rails.env # paperclip - http://stackoverflow.com/questions/17333072/railspaperclipimagemagickwindows-7-got-error-500
    validates :logo, presence: true
  end
  validate :cant_be_public_if_not_ready_for_approval

  def stories
    list = []
    projects.each do |project|
      project.stories.each { |story| list << story }
    end
    list
  end

  def change_score
    projects.sum(&:change_score).to_i
  end

  def change_progress
    total = projects.sum(&:change_progress)
    progress = total / projects.count if projects.any?
    progress = 100 if progress > 100
    progress
  end

  def projects_leaders
    list = []
    projects.each { |project| list << project.leader if project.leader }
    list.uniq
  end

  def makes
    list = []
    projects.each do |project|
      project.projects_makes.active.each do |project_make|
        list << project_make.make if project_make.make
      end
    end
    list
  end

  def causes
    causes = []
    projects.each do |project|
      project.causes.each { |cause| causes << cause }
    end
    causes.uniq
  end

  def colleagues
    (reporters + editors).uniq
  end

  def donors
    []
  end

  def current_donors
    []
  end

  def donors_wanted_to_give_again
    []
  end

  def path
    Rails.application.routes.url_helpers.charity_path(self)
  end

  def self.get_merchant_customer(charity, user)
    if charity.stripe_merchant
      merchant_access_token = charity.stripe_merchant.access_token
      stripe_customer = StripeCustomer.find_or_create_by_charity_id_and_user_id(charity.id, user.id)

      if stripe_customer.customer_id
        merchant_customer = Stripe::Customer.retrieve(stripe_customer.customer_id, merchant_access_token)
      else
        # Find and save shared customer
        if customer = user.stripe_customer
          token = Stripe::Token.create({
            customer: customer.customer_id
          }, merchant_access_token)

          merchant_customer = Stripe::Customer.create({
            email: user.email,
            card: token.id
          }, merchant_access_token)

          stripe_customer.customer_id = merchant_customer.id
          stripe_customer.save
        end
      end

      merchant_customer
    else
      charity.is_public = false
      charity.save
      false
    end
  end

  def leader
    read_attribute(:leader) || self.editors.first
  end

  def add_leader(user)
    self.editors << user
    self.leader = user
  end

  def add_member(user)
    self.editors << user
  end

  extend FriendlyId
  friendly_id :name, use: :slugged

  def charity_regulator_enum
    CharityRegulators.all
  end

  def my_charity_regulator
    [ CharityRegulators.selected_regulator(charity_regulator), charity_regulator ]
  end

  rails_admin do
    edit do
      exclude_fields :slug, :followings, :go_cardless_merchant, :stripe_merchant, :stripe_customers, :subscriptions, :donations
      configure :charity_regulator, :enum do
        def form_value
          bindings[:object].my_charity_regulator
        end

        multiple do
          false
        end

        def render
          bindings[:view].render :partial => "form_enumeration_with_other", :locals => {:field => self, :form => bindings[:form]}
        end
      end
    end
  end

  private
    def after_add_colleague(user)
      if Rails.env.production?
        NotificationsMailer.delay.added_new_colleague_to_a_charity(user, self)
      else
        NotificationsMailer.added_new_colleague_to_a_charity(user, self).deliver unless Rails.env.development?
      end
    end

    def cant_be_public_if_not_ready_for_approval
      if is_public && !(chv1? && contract? && paying_in_slip? && hmrc_number.present? && charity_regulator.present?)
        errors.add(:base, I18n.t('activerecord.errors.messages.models.charity.attributes.is_public'))
      end
    end
end
