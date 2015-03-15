class AddIntelligentMatchingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :intelligent_matching, :boolean, default: true
  end
end
