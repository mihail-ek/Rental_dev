class AddAttachmentIconToMakes < ActiveRecord::Migration
  def self.up
    change_table :makes do |t|
      t.attachment :icon
    end
  end

  def self.down
    drop_attached_file :makes, :icon
  end
end
