class Story < ActiveRecord::Base
  acts_as_votable # favorites

  belongs_to :change
  belongs_to :project

  attr_accessible :text, :change_id, :number, :approved, :project_id
  attr_accessible :top_up_ids, :comment_ids

  has_many :top_ups, :as => :topupable
  has_many :comments, :as => :commentable, :dependent => :destroy

  validates :project, presence: true
  validates :text, presence: true, length: { maximum: 255 }
  validates :change, presence: true
  validates :number, presence: true

  attr_accessible :media
  has_attached_file :media,
                    :styles => { square: "200x200#", small: "400x400>", cover: "400x150#" },
                    :path => "stories/:id/media/:style/:filename"
  validates_attachment_content_type :media, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  def title
    "#{number} #{change.name.downcase if change}"
  end
end
