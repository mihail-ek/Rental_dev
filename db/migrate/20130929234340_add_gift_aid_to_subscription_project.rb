class AddGiftAidToSubscriptionProject < ActiveRecord::Migration
  def change
    add_column :subscription_projects, :gift_aid, :boolean, default: false
  end
end
