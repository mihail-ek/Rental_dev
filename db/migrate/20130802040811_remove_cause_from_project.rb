class RemoveCauseFromProject < ActiveRecord::Migration
  def up
    remove_column :projects, :cause_id
  end

  def down
    add_column :projects, :cause_id, :integer
  end
end
