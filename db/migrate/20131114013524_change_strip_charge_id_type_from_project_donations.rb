class ChangeStripChargeIdTypeFromProjectDonations < ActiveRecord::Migration
  def up
    change_column :project_donations, :stripe_charge_id, :string
  end

  def down
    change_column :project_donations, :stripe_charge_id, :integer
  end
end
