class AddPaidToProjectDonations < ActiveRecord::Migration
  def change
    add_column :project_donations, :paid, :boolean
  end
end
