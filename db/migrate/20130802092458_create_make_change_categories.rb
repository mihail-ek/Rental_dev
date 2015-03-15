class CreateMakeChangeCategories < ActiveRecord::Migration
  def change
    create_table :make_change_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
