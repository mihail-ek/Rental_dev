class WelcomeMessage < ActiveRecord::Base
  belongs_to :project
  attr_accessible :project_id, :headline, :text

  attr_accessible :image
  has_attached_file :image,
                    :styles => { square: "200x200#", small: "400x400>", cover: "400x150#" },
                    :path => "welcome-messages/:id/image/:style/:filename"
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/jpg', 'image/png']

  validates :project, presence: true
  validates :headline, presence: true, length: { maximum: 50 }
  if [:staging, :production].include? Rails.env # paperclip - http://stackoverflow.com/questions/17333072/railspaperclipimagemagickwindows-7-got-error-500
    validates :image, presence: true
  end
  validates :text, presence: true, length: { maximum: 200 }
end
