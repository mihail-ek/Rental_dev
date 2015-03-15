class Media < ActiveRecord::Base
  attr_accessible :name
  attr_accessible :mediable, :polymorphic => true

  attr_accessible :file
  has_attached_file :file,
                    :path => "medias/:id/file/:style/:filename"
  validates_attachment_content_type :file, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
end
