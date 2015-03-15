class AddEndedAtToSubscriptionProject < ActiveRecord::Migration
  def change
    add_column :subscription_projects, :ended_at, :datetime
  end
end
