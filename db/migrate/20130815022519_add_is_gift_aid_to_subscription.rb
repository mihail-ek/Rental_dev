class AddIsGiftAidToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :is_gift_aid, :boolean
  end
end
