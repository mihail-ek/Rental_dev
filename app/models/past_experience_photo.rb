class PastExperiencePhoto < ActiveRecord::Base
  belongs_to :project

  validates_presence_of :project

  attr_accessible :photo

  has_attached_file :photo,
                    :styles => { square: "200x200#", small: "400x400>" },
                    :path => "projects/past_experience/:id/image/:style/:filename"

  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
end
