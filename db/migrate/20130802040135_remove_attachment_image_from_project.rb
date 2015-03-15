class RemoveAttachmentImageFromProject < ActiveRecord::Migration
  def self.up
    drop_attached_file :projects, :image
  end

  def self.down
    change_table :projects do |t|
      t.attachment :image
    end
  end
end
