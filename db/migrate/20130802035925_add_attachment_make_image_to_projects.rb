class AddAttachmentMakeImageToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.attachment :make_image
    end
  end

  def self.down
    drop_attached_file :projects, :make_image
  end
end
