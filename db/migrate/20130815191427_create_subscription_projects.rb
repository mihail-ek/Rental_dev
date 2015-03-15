class CreateSubscriptionProjects < ActiveRecord::Migration
  def change
    create_table :subscription_projects do |t|
      t.references :project
      t.references :subscription

      t.timestamps
    end
    add_index :subscription_projects, :project_id
    add_index :subscription_projects, :subscription_id
  end
end
