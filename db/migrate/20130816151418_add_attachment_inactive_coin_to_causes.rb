class AddAttachmentInactiveCoinToCauses < ActiveRecord::Migration
  def self.up
    change_table :causes do |t|
      t.attachment :inactive_coin
    end
  end

  def self.down
    drop_attached_file :causes, :inactive_coin
  end
end
