class Change < ActiveRecord::Base
  belongs_to :make_change_category
  has_many :stories
  has_many :projects_changes
  attr_accessible :name, :sanitized_name, :story_ids, :make_change_category_id

  attr_accessible :icon
  has_attached_file :icon,
                    :styles => { square: "50x50#", small: "150x150#", normal: "400x400#" },
                    :path => "changes/:id/icon/:style/:filename",
                    :default_url => "assets/changes/icon/:style/icon.png"
  validates_attachment_content_type :icon, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  validates :name, presence: true
  validates :sanitized_name, presence: true
  validates :make_change_category_id, presence: true
  validates :icon, presence: true
end
