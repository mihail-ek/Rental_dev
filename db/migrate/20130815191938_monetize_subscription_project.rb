class MonetizeSubscriptionProject < ActiveRecord::Migration
  def change
    add_money :subscription_projects, :amount
  end
end
