class CreateMakes < ActiveRecord::Migration
  def change
    create_table :makes do |t|
      t.string :name
      t.string :sanitized_name

      t.timestamps
    end
  end
end
