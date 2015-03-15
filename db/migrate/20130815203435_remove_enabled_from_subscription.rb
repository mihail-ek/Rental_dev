class RemoveEnabledFromSubscription < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :enabled
  end
end
