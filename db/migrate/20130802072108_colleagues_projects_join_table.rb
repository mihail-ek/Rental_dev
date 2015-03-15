class ColleaguesProjectsJoinTable < ActiveRecord::Migration
  def up
    create_table :colleagues_projects, { :id => false } do |t|
      t.column :project_id, :integer
      t.column :user_id, :integer
    end
    drop_table :charities_colleagues
  end

  def down
    drop_table :colleagues_projects
    create_table :charities_colleagues, { :id => false } do |t|
      t.column :charity_id, :integer
      t.column :user_id, :integer
    end
  end
end
