class RemoveMoneyFromSubscription < ActiveRecord::Migration
  def change
    remove_money :subscriptions, :amount
  end
end
