class AddMerchantIdToGoCardlessMerchant < ActiveRecord::Migration
  def change
    add_column :go_cardless_merchants, :merchant_id, :string
  end
end
