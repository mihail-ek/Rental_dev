require 'spec_helper'

describe ProjectMailer do
  context '#submit_project_to_requester' do
    it "should be set to be delivered to the requester" do
      project = build(:project_approved)
      requester = project.leader

      email = ProjectMailer.submit_project_to_requester(project)

      email.should deliver_to(requester.email)
    end

    it "should contain the requester's name" do
      project = build(:project_approved)
      requester = project.leader

      email = ProjectMailer.submit_project_to_requester(project)

      email.should have_body_text(/#{requester.name}/)
    end

    it "should have the correct subject" do
      email = ProjectMailer.submit_project_to_requester create(:project_approved)

      email.should have_subject(/#{I18n.t('mailer.project_mailer.submit_project.subject')}/)
    end

    it "should have the project's attributes" do
      project = create(:project_approved)
      email = ProjectMailer.submit_project_to_requester project

      email.should have_body_text(/#{project.name}/)
    end
  end

  context '#submit_project_to_charity_master_admin' do
    it "should be set to be delivered to the charity master admin" do
      project = build(:project_approved)
      requester_email = ENV['CHARITY_MASTER_ADMIN_EMAIL']

      email = ProjectMailer.submit_project_to_charity_master_admin(project)

      email.should deliver_to(requester_email)
    end

    it "should have the correct subject" do
      email = ProjectMailer.submit_project_to_charity_master_admin create(:project_approved)

      email.should have_subject(/#{I18n.t('mailer.project_mailer.submit_project.subject')}/)
    end

    it "should have the project's attributes" do
      project = create(:project_approved)
      email = ProjectMailer.submit_project_to_charity_master_admin project

      email.should have_body_text(/#{project.name}/)
    end
  end
end
