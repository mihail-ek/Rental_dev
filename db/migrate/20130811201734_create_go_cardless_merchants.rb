class CreateGoCardlessMerchants < ActiveRecord::Migration
  def change
    create_table :go_cardless_merchants do |t|
      t.references :charity
      t.string :access_token

      t.timestamps
    end
    add_index :go_cardless_merchants, :charity_id
  end
end
