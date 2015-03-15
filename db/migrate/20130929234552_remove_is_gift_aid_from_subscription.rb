class RemoveIsGiftAidFromSubscription < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :is_gift_aid
  end
end
