class CausesUsers < ActiveRecord::Migration
  def self.up
    create_table :causes_users, :id => false do |t|
        t.references :cause
        t.references :user
    end
    add_index :causes_users, [:cause_id, :user_id]
    add_index :causes_users, :user_id
  end

  def self.down
    drop_table :causes_users
  end
end
