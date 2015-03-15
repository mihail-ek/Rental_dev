class AddFieldsToStripeMerchant < ActiveRecord::Migration
  def change
    add_column :stripe_merchants, :token_type, :string
    add_column :stripe_merchants, :scope, :string
    add_column :stripe_merchants, :livemode, :string
    add_column :stripe_merchants, :refresh_token, :string
  end
end
