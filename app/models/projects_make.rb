class ProjectsMake < ActiveRecord::Base
  belongs_to :project
  belongs_to :make
  has_many :project_donations
  monetize :cost_pennies
  attr_accessible :project_id, :make_id, :cost, :intent
  attr_accessible :cost_pennies, :cost_currency
  attr_accessible :project_donation_ids

  # validates :project_id, presence: true # BUG with form when enabled
  validates :make_id, presence: true
  validates :cost, presence: true

  scope :active, -> { where('project_id is NOT NULL') }

  def donations_total_uncensored
    amount = Money.new(0, "GBP")
    project_donations.each { |donation| amount += donation.amount }
    amount
  end

  def donations_total
    amount = donations_total_uncensored
    amount = cost if amount > cost
    amount
  end

  def progress
    (donations_total / cost * 100).to_i
  end

  def completed?
    cost == donations_total
  end

  def to_s
    [make.name, "#{ActionController::Base.helpers.humanized_money_with_symbol cost}", intent].join ', '
  end
end
