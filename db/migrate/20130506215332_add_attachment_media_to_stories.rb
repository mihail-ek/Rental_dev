class AddAttachmentMediaToStories < ActiveRecord::Migration
  def self.up
    change_table :stories do |t|
      t.attachment :media
    end
  end

  def self.down
    drop_attached_file :stories, :media
  end
end
