class CreateSubCauses < ActiveRecord::Migration
  def change
    create_table :sub_causes do |t|
      t.string :name, null: false, default: ""
      t.references :cause

      t.timestamps
    end
    add_index :sub_causes, :cause_id
  end
end
