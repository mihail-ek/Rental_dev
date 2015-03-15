class AddEnabledToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :enabled, :boolean, default: false
  end
end
