class Achievement < ActiveRecord::Base
  acts_as_votable # favorites
  
  belongs_to :user
  belongs_to :project
  belongs_to :change
  
  attr_accessible :title, :text, :change_id, :number, :user_id, :project_id
  attr_accessible :top_up_ids, :comment_ids

  has_many :top_ups, :as => :topupable
  has_many :comments, :as => :commentable, :dependent => :destroy

  validates :user, presence: true
  validates :project, presence: true
  validates :text, length: { maximum: 255 }

  attr_accessible :media
  has_attached_file :media,
                    :styles => { square: "200x200#", small: "400x400>", cover: "400x150#" },
                    :path => "achievements/:id/media/:style/:filename"
  validates_attachment_content_type :media, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
end
