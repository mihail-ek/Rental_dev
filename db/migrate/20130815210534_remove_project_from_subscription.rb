class RemoveProjectFromSubscription < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :project_id
  end
end
