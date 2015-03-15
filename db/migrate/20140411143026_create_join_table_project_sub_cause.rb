class CreateJoinTableProjectSubCause < ActiveRecord::Migration
  def change
    create_table :projects_sub_causes, { id: false } do |t|
      t.references :project
      t.references :sub_cause
    end
    add_index :projects_sub_causes, :project_id
    add_index :projects_sub_causes, :sub_cause_id
  end
end
