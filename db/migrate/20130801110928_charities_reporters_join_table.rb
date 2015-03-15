class CharitiesReportersJoinTable < ActiveRecord::Migration
  def up
    create_table :charities_reporters, {:id => false } do |t|
      t.column :charity_id, :integer
      t.column :user_id, :integer
    end
  end

  def down
    drop_table :charities_reporters
  end
end
