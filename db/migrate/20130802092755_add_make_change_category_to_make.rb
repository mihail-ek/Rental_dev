class AddMakeChangeCategoryToMake < ActiveRecord::Migration
  def change
    add_column :makes, :make_change_category_id, :integer
    add_index :makes, :make_change_category_id
  end
end
