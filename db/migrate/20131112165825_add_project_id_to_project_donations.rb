class AddProjectIdToProjectDonations < ActiveRecord::Migration
  def change
    add_column :project_donations, :project_id, :integer
    add_index :project_donations, :project_id
  end
end
