class RemoveGiftAidFromDonation < ActiveRecord::Migration
  def change
    remove_column :donations, :gift_aid
  end
end
