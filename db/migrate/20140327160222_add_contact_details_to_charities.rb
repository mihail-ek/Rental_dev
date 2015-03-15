class AddContactDetailsToCharities < ActiveRecord::Migration
  def change
    add_column :charities, :landline_phone, :string
    add_column :charities, :mobile_phone, :string
    add_column :charities, :skype, :string
    add_column :charities, :email, :string
    add_column :charities, :office_address, :string
    add_column :charities, :registered_charity_address, :string
    add_column :charities, :notes, :text
  end
end
