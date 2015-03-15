class MonetizeSubscription < ActiveRecord::Migration
  def change
    add_money :subscriptions, :amount
  end
end
