class AddLeaderToCharity < ActiveRecord::Migration
  def change
    add_column :charities, :leader_id, :integer
    add_index :charities, :leader_id
  end
end
