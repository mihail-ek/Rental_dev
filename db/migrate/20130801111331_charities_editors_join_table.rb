class CharitiesEditorsJoinTable < ActiveRecord::Migration
  def up
    create_table :charities_editors, {:id => false } do |t|
      t.column :charity_id, :integer
      t.column :user_id, :integer
    end
  end
  
  def down    
    drop_table :charities_editors
  end
end
