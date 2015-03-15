class CreateWelcomeMessages < ActiveRecord::Migration
  def change
    create_table :welcome_messages do |t|
      t.string :headline
      t.text :text

      t.timestamps
    end
  end
end
