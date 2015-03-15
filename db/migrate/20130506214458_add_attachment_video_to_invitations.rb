class AddAttachmentVideoToInvitations < ActiveRecord::Migration
  def self.up
    change_table :invitations do |t|
      t.attachment :video
    end
  end

  def self.down
    drop_attached_file :invitations, :video
  end
end
