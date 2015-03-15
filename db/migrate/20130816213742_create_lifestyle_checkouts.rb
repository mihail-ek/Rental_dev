class CreateLifestyleCheckouts < ActiveRecord::Migration
  def change
    create_table :lifestyle_checkouts do |t|
      t.string :name

      t.timestamps
    end
  end
end
