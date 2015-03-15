class AddAttachmentMediaToAchievements < ActiveRecord::Migration
  def self.up
    change_table :achievements do |t|
      t.attachment :media
    end
  end

  def self.down
    drop_attached_file :achievements, :media
  end
end
