class CausesProjectsJoinTable < ActiveRecord::Migration
  def up
    create_table :causes_projects, {:id => false } do |t|
      t.column :cause_id, :integer
      t.column :project_id, :integer
    end
  end
  
  def down    
    drop_table :causes_projects
  end
end
