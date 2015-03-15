class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :problem
      t.text :solution
      t.integer :leader_id
      t.references :cause

      t.timestamps
    end
    add_index :projects, :cause_id
    add_index :projects, :leader_id
  end
end
