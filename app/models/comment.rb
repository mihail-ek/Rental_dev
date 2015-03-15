class Comment < ActiveRecord::Base
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :text, :user_id, :comment_ids
  attr_accessible :commentable_type, :commentable_id

  validates :text, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true
  validates :commentable_type, presence: true
  validates :commentable_id, presence: true

  def to_s
    text
  end
end
