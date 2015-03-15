class Project < ActiveRecord::Base
  belongs_to :charity
  belongs_to :leader, :class_name => 'User', :foreign_key => 'leader_id'

  scope :public, -> { joins(:charity).where('charities.is_public' => true, approved: true) }
  scope :unfunded, -> { where(is_funded: false) }
  scope :funded, -> { where(is_funded: true) }
  scope :draft, -> { where(draft: true) }

  has_many :welcome_messages, inverse_of: :project
  accepts_nested_attributes_for :welcome_messages, reject_if: :all_blank, allow_destroy: true
  has_many :faqs
  accepts_nested_attributes_for :faqs, reject_if: :all_blank, allow_destroy: true

  has_many :medias, :as => :mediable
  has_many :stories, dependent: :destroy

  has_many :subscription_projects
  has_many :subscriptions, through: :subscription_projects

  has_many :projects_makes
  accepts_nested_attributes_for :projects_makes, reject_if: :all_blank, allow_destroy: true
  has_many :projects_changes
  accepts_nested_attributes_for :projects_changes, reject_if: :all_blank, allow_destroy: true
  # alias_attribute :makes, :projects_makes > TypeError: can't convert Symbol into Integer
  # alias_attribute :changes, :projects_changes

  has_many :project_donations

  has_many :past_experience_photos, class_name: 'PastExperiencePhoto', inverse_of: :project, dependent: :destroy

  has_and_belongs_to_many :reporters, :class_name=> "User", join_table: :projects_reporters, :after_add => :after_add_colleague
  has_and_belongs_to_many :editors, :class_name=> "User", join_table: :editors_projects, :after_add => :after_add_colleague
  has_and_belongs_to_many :causes
  has_and_belongs_to_many :sub_causes
  accepts_nested_attributes_for :sub_causes, reject_if: :all_blank, allow_destroy: true

  attr_accessible :name, :headline, :approved, :is_funded, :activities, :url, :location
  attr_accessible :leader_id, :charity_id
  attr_accessible :cause_ids, :faq_id, :media_ids, :story_ids, :editor_ids, :reporter_ids
  attr_accessible :tag_list, :method_list, :problem_list, :problem_statistic_list, :change_tag_list, :budget_confirmation
  attr_accessible :projects_makes_attributes, :projects_changes_attributes, :welcome_messages_attributes, :faqs_attributes
  attr_accessible :projects_make_ids, :projects_change_ids
  attr_accessible :past_experience_photos, :draft

  attr_accessible :help_statement, :beneficiaries, :change_statement
  attr_accessible :problem, :solution, :help_description, :make_statement, :past_experience
  alias_attribute :help_description, :problem
  alias_attribute :make_statement, :solution

  attr_accessible :help_image
  has_attached_file :help_image,
                    :styles => { square: "200x200#", small: "400x400>", to_add: "362x270#", you_might_like: "260x160#" },
                    path: "projects/:id/image/:style/:filename",
                    :default_url => "/assets/projects/help_image/:style/default.jpg"
  validates_attachment_content_type :help_image, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  attr_accessible :make_image
  has_attached_file :make_image,
                    :styles => { square: "200x200#", small: "400x400>", to_add: "362x270#", you_might_like: "260x160#" },
                    path: "projects/:id/image/:style/:filename",
                    :default_url => "/assets/projects/make_image/:style/default.jpg"
  validates_attachment_content_type :make_image, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  attr_accessible :image
  alias_attribute :image, :help_image
  alias_attribute :headline, :name

  validates :headline, presence: true, unless: :draft?
  if [:staging, :production].include? Rails.env # paperclip - http://stackoverflow.com/questions/17333072/railspaperclipimagemagickwindows-7-got-error-500
    validates :help_image, presence: true, unless: :draft?
  end
  validates :help_description, presence: true, unless: :draft?
  if [:staging, :production].include? Rails.env # paperclip - http://stackoverflow.com/questions/17333072/railspaperclipimagemagickwindows-7-got-error-500
    validates :make_image, presence: true, unless: :draft?
  end
  validates :make_statement, presence: true, unless: :draft?
  validates :causes, presence: true, unless: :draft?
  validate :budget_confirmation do |bc|
    errors.add :budget_confirmation, "You need to confirm that your charity has budget to run this project anyway and can therefore proceed to run this project even if no funds are raised on Makerble" if !self.draft? && !self.budget_confirmation
  end
  validate :validate_active_makes_and_changes, unless: :draft?

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :methods
  acts_as_taggable_on :problems
  acts_as_taggable_on :problem_statistics
  acts_as_taggable_on :change_tags

  def current_project_make
    current = nil
    projects_makes.each do |project_make|
      current = project_make unless project_make.completed?
      break if current
    end
    current
  end

  def previous_project_make
    previous = nil
    projects_makes.reverse.each do |project_make|
      previous = project_make if project_make.completed?
      break if previous
    end
    previous
  end

  def makes_cost
    cost = Money.new(0, 'GBP')
    projects_makes.each { |project_make| cost += project_make.cost }
    cost
  end

  def donations_total
    amount = Money.new(0, "GBP")
    project_donations.paid.each { |donation| amount += donation.amount }
    amount
  end

  def current_project_change
    current = nil
    projects_changes.each do |project_change|
      current = project_change unless project_change.completed?
      break if current
    end
    current
  end

  def previous_project_change
    previous = nil
    projects_changes.reverse.each do |project_change|
      previous = project_change if project_change.completed?
      break if previous
    end
    previous
  end

  def welcome_message
    welcome_messages.first
  end

  def days_remaining
    0
  end

  def change_score
    stories.sum(&:number).to_i
  end

  def change_total
    projects_changes.sum(&:number).to_i
  end

  def change_progress # 0-100
    progress = if change_total > 0
                 (change_score.to_f / change_total.to_f) * 100
               else
                 0
               end
    progress = 100 if progress > 100
    progress.to_i
  end

  def followers
    []
  end

  def top_ups
    []
  end

  def makers
    project_donations.paid.map(&:user).uniq
  end

  def makers_recruited_through_updates
    []
  end

  def makers_recruited_by_friends
    []
  end

  def related_projects
    list = charity.projects.public
    number = 6 - list.count
    if number > 0
      Project.public.unfunded.first(number).each { |project| list << project }
    end
    list.uniq
    list.delete_if { |project| project == self }
  end

  def colleagues
    (editors + reporters).uniq
  end

  def public?
    charity.is_public && approved
  end

  def funded?
    is_funded
  end

  def path
    Rails.application.routes.url_helpers.project_path(self.slug.presence || self.id)
  end

  def edit_path
    Rails.application.routes.url_helpers.edit_charity_project_path(self.charity_id, (self.slug.presence || self.id))
  end

  def update_path
    Rails.application.routes.url_helpers.charity_project_path(self.charity_id, (self.slug.presence || self.id))
  end

  def sub_cause_list(cause_id)
    sub_causes.where(cause_id: cause_id).map(&:name).join(',')
  end

  def past_experience_photos=(photos)
    photos.each { |photo| self.past_experience_photos.build(photo: photo) }
  end

  def add_leader(user)
    self.editors << user
    self.leader = user
  end

  def present_status
    if self.draft?
      I18n.t('helpers.draft')
    elsif self.approved?
      I18n.t('helpers.approved')
    else
      I18n.t('helpers.pending_approval')
    end
  end

  def help_inputs
    ProjectPresentableInputs.help_inputs
  end

  def make_inputs
    ProjectPresentableInputs.make_inputs
  end

  def change_inputs
    ProjectPresentableInputs.change_inputs
  end

  def more_info_inputs
    ProjectPresentableInputs.more_info_inputs
  end

  extend FriendlyId
  friendly_id :name, use: :slugged

  private
    def validate_active_makes_and_changes
      if self.projects_makes.empty? || self.projects_changes.empty?
        errors.add(:makes_and_changes, "The project needs to have at least one active make item and on active change item")
      end
    end

    def after_add_colleague(user)
      if Rails.env.production?
        NotificationsMailer.delay.added_new_colleague_to_a_project(user, self)
      else
        NotificationsMailer.added_new_colleague_to_a_project(user, self).deliver unless Rails.env.development?
      end
    end
end
