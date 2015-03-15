class AddAttachmentHelpImageToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.attachment :help_image
    end
  end

  def self.down
    drop_attached_file :projects, :help_image
  end
end
