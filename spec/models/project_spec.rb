require 'spec_helper'

describe Project do
  it { should have_and_belong_to_many(:causes) }
  it { should have_and_belong_to_many(:sub_causes) }
  it { should have_many(:welcome_messages) }
  it { should accept_nested_attributes_for(:welcome_messages) }

  it { should accept_nested_attributes_for(:sub_causes).allow_destroy(true) }

  it "shouldn't require any attribute when the project is a draft" do
    project = Project.new
    project.should be_valid
  end

  context "#sub_cause_list" do
    it "returns a string containing the project's sub causes for a specific cause delimited with commas" do
      project = create :project
      project.sub_causes.build [{name: "tag1", cause_id: 1}, {name: "tag2", cause_id: 1}]
      project.save

      expect(project.sub_cause_list(1)).to eq "tag1,tag2"
    end
  end

  context '#past_experience_photos=' do
    it 'builds the association past_experience_photos' do
      project = Project.new

      project.past_experience_photos = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/default.png", 'image/png')]

      expect(project.past_experience_photos).to be
      expect(project.past_experience_photos.first).to be_an_instance_of PastExperiencePhoto
    end
  end

  context '.draft' do
    it "is a draft when the project hasn't been submitted by the user" do
      project = create :project

      expect(Project.draft).to include project
    end

    it "is not a draft when the project has been submitted to be approved" do
      project = create(:project, draft: false)

      expect(Project.draft).not_to include project
    end
  end

  context '#add_leader' do
    it 'assigns the leader' do
      user = build_stubbed :user
      project = Project.new
      project.add_leader user

      expect(project.leader).to eq user
    end

    it 'adds an editor' do
      user = build_stubbed :user
      project = Project.new
      project.add_leader user

      expect(project.editors).to include user
    end
  end
end
