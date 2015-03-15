class ProjectsChange < ActiveRecord::Base
  belongs_to :project
  belongs_to :change
  attr_accessible :project_id, :change_id, :number, :project, :change

  # validates :project_id, presence: true # BUG with form when enabled
  validates :change_id, presence: true
  validates :number, presence: true

  scope :active, -> { where('project_id is NOT NULL') }

  def changes_total
    total = 0
    project.stories.each { |story| total += story.number.to_i }
    total = number if total > number
    total
  end

  def progress
    (changes_total / number).to_i
  end

  def completed?
    number == changes_total
  end

  def to_s
    [change.name, number].join ', '
  end
end
