class RemoveEndedAtFromSubscriptionProject < ActiveRecord::Migration
  def change
    remove_column :subscription_projects, :ended_at
  end
end
