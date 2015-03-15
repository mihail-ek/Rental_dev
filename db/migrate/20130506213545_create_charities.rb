class CreateCharities < ActiveRecord::Migration
  def change
    create_table :charities do |t|
      t.string :name
      t.text :description
      t.text :address
      t.string :number

      t.timestamps
    end
  end
end
