class AddAttachmentIconToChanges < ActiveRecord::Migration
  def self.up
    change_table :changes do |t|
      t.attachment :icon
    end
  end

  def self.down
    drop_attached_file :changes, :icon
  end
end
