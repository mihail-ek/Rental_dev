class AddAttachmentIconToLifestyleCheckouts < ActiveRecord::Migration
  def self.up
    change_table :lifestyle_checkouts do |t|
      t.attachment :icon
    end
  end

  def self.down
    drop_attached_file :lifestyle_checkouts, :icon
  end
end
