class SubCause < ActiveRecord::Base
  belongs_to :cause
  has_and_belongs_to_many :projects

  attr_accessible :name, :cause_id

  validates :cause, :name, presence: true
  validates_uniqueness_of :name, scope: :cause_id
end
