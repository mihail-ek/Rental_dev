class AddAttachmentImageToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :projects, :image
  end
end
