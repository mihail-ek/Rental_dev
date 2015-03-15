class Cause < ActiveRecord::Base
  attr_accessible :name, :project_ids, :user_ids
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :users
  has_many :sub_causes, dependent: :destroy, inverse_of: :cause
  accepts_nested_attributes_for :sub_causes, reject_if: :all_blank, allow_destroy: true

  attr_accessible :coin
  has_attached_file :coin,
                    :styles => { icon: "25x25#", small: "200x200#", medium: "400x400#", big: "800x800#" },
                    :path => "causes/:id/coin/:style/:filename",
                    :default_url => '/assets/causes/coins/:style/missing.png'
  validates_attachment_content_type :coin, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  attr_accessible :inactive_coin
  has_attached_file :inactive_coin,
                    :styles => { icon: "25x25#", small: "200x200#", medium: "400x400#", big: "800x800#" },
                    :path => "causes/:id/inactive_coin/:style/:filename",
                    :default_url => '/assets/causes/inactive_coins/:style/missing.png'
  validates_attachment_content_type :inactive_coin, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  def path
    Rails.application.routes.url_helpers.cause_path(self)
  end

  def sub_cause_list
    sub_causes.map(&:name).join(',')
  end

  def to_s
    causes = name
    causes << ': ' + sub_causes.map(&:name).join(', ') if sub_causes.present?
    causes
  end
end
