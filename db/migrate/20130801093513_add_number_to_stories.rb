class AddNumberToStories < ActiveRecord::Migration
  def change
    add_column :stories, :number, :string
  end
end
