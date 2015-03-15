class CreatePastExperiencePhotos < ActiveRecord::Migration
  def change
    create_table :past_experience_photos do |t|
      t.references :project
      t.attachment :photo

      t.timestamps
    end
    add_index :past_experience_photos, :project_id
  end
end
