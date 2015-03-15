class AddGiftAidToProjectDonation < ActiveRecord::Migration
  def change
    add_column :project_donations, :gift_aid, :boolean, default: false
  end
end
