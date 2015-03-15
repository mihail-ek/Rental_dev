class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.text :text
      t.integer :sender_id
      t.integer :receiver_id
      t.references :project

      t.timestamps
    end
    add_index :invitations, :project_id
    add_index :invitations, :sender_id
    add_index :invitations, :receiver_id
  end
end
