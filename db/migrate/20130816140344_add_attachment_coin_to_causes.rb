class AddAttachmentCoinToCauses < ActiveRecord::Migration
  def self.up
    change_table :causes do |t|
      t.attachment :coin
    end
  end

  def self.down
    drop_attached_file :causes, :coin
  end
end
