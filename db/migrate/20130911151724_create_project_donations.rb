class CreateProjectDonations < ActiveRecord::Migration
  def change
    create_table :project_donations do |t|
      t.references :user
      t.references :projects_make

      t.timestamps
    end
    add_money :project_donations, :amount
    add_index :project_donations, :user_id
    add_index :project_donations, :projects_make_id
  end
end
