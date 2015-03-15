class AddApplicationFeePercentToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :application_fee_percent, :integer
  end
end
