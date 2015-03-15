class AddCharitiesUsersTable < ActiveRecord::Migration
  create_table :charities_users do |t|
    t.belongs_to :charity
    t.belongs_to :user
  end
end
