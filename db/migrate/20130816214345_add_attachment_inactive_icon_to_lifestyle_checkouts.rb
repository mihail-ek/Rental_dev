class AddAttachmentInactiveIconToLifestyleCheckouts < ActiveRecord::Migration
  def self.up
    change_table :lifestyle_checkouts do |t|
      t.attachment :inactive_icon
    end
  end

  def self.down
    drop_attached_file :lifestyle_checkouts, :inactive_icon
  end
end
