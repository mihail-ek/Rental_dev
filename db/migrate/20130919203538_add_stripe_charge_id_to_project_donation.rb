class AddStripeChargeIdToProjectDonation < ActiveRecord::Migration
  def change
    add_column :project_donations, :stripe_charge_id, :integer
  end
end
