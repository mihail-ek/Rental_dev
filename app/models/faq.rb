class Faq < ActiveRecord::Base
  belongs_to :project
  has_many :comments, as: :commentable, dependent: :destroy

  attr_accessible :name, :project_id, :comment_ids

  validates :project_id, presence: true

  def question
    comments.first
  end

  def answer
    if question
      question.comments.first
    end
  end

  def to_s
    "Q: #{question}\nA: #{answer}"
  end
end
