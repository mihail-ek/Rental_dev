class AddAttachmentImageToWelcomeMessages < ActiveRecord::Migration
  def self.up
    change_table :welcome_messages do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :welcome_messages, :image
  end
end
