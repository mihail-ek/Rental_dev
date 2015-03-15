class SubscriptionProject < ActiveRecord::Base
  belongs_to :project
  belongs_to :subscription
  
  attr_accessible :project, :subscription, :amount
  attr_accessible :project_id, :subscription_id
  attr_accessible :amount_pennies, :amount_currency
  attr_accessible :gift_aid
 
  scope :active, -> { where('project_id is NOT NULL') }

  monetize :amount_pennies

  validates :project_id, uniqueness: { scope: :subscription_id }
end
