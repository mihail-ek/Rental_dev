class AddAttachmentsToCharities < ActiveRecord::Migration
  def change
    change_table :charities do |t|
      t.attachment :chv1
      t.attachment :contract
      t.attachment :paying_in_slip
    end
  end
end
