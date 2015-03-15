class ProjectDonation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :projects_make
  monetize :amount_pennies

  scope :paid, -> { where(paid: true) }

  attr_accessible :user_id, :projects_make_id, :amount_pennies, :amount_currency, :stripe_charge_id
  attr_accessible :gift_aid, :project_id, :paid

  validates :stripe_charge_id, uniqueness: { scope: :projects_make_id }
end
