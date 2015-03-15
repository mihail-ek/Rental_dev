class Invitation < ActiveRecord::Base
  belongs_to :project
  belongs_to :sender, :class_name => 'User', :foreign_key => 'sender_id'
  belongs_to :receiver, :class_name => 'User', :foreign_key => 'receiver_id'
  
  attr_accessible :receiver_id, :sender_id, :text

  attr_accessible :video
  has_attached_file :video,
                    :path => "invitations/:id/video/:style/:filename"
  validates_attachment_content_type :video, :content_type => ['image/jpeg', 'image/jpg', 'image/png']
end
