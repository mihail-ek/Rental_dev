require 'spec_helper'

describe PastExperiencePhoto do
  it { should belong_to(:project) }

  it { should validate_presence_of(:project) }
  it { should have_attached_file(:photo) }
  it { should validate_attachment_content_type(:photo).allowing('image/png', 'image/jpg', 'image/jpeg') }
end
