require 'spec_helper'

describe CharityJoinRequestMailer do
  context '#create_request' do
    it "should be set to be replied to the email passed in" do
      charity_join_request = build(:charity_join_request, charity: create(:charity))
      email = CharityJoinRequestMailer.create_request(charity_join_request)

      email.should reply_to(charity_join_request.user.email)
    end

    it "should be set to be delivered to the charity's admins" do
      charity_admin = create :user
      charity = create :charity, leader: charity_admin
      charity_join_request = build(:charity_join_request, charity: charity)

      email = CharityJoinRequestMailer.create_request(charity_join_request)

      email.should deliver_to([charity_admin.email])
    end

    it "should contain the requester's message in the mail body" do
      charity_join_request = build(:charity_join_request, charity: create(:charity))

      email = CharityJoinRequestMailer.create_request(charity_join_request)

      email.should have_body_text(/#{charity_join_request.message}/)
    end

    it "should contain a link to the Charity Admin Dashboard" do
      charity_join_request = build(:charity_join_request, charity: create(:charity))

      email = CharityJoinRequestMailer.create_request(charity_join_request)

      email.should have_body_text(/#{approvals_new_staff_url}/)
    end

    it "should have the correct subject" do
      email = CharityJoinRequestMailer.create_request(build(:charity_join_request))

      email.should have_subject(/#{I18n.t('mailer.charity_join_request_mailer.create_request.subject')}/)
    end
  end

  context '#approve_request_to_requester' do
    it "should be set to be delivered to the requester" do
      requester = build_stubbed :user
      charity_join_request = build(:approved_charity_join_request, user: requester)

      email = CharityJoinRequestMailer.approve_request_to_requester(charity_join_request)

      email.should deliver_to(requester.email)
    end

    it "should contain the requester's name" do
      requester = build_stubbed :user
      charity_join_request = build(:approved_charity_join_request, user: requester)

      email = CharityJoinRequestMailer.approve_request_to_requester(charity_join_request)

      email.should have_body_text(/#{requester.name}/)
    end

    it "should contain the admin's name" do
      admin = build_stubbed :user
      charity_join_request = build(:approved_charity_join_request, admin: admin)

      email = CharityJoinRequestMailer.approve_request_to_requester(charity_join_request)

      email.should have_body_text(/#{admin.name}/)
    end

    it "should have the correct subject" do
      charity = build :charity
      email = CharityJoinRequestMailer.approve_request_to_requester build_stubbed(:approved_charity_join_request, charity: charity)

      email.should have_subject(/#{I18n.t('mailer.charity_join_request_mailer.approve_request_to_requester.subject', charity: charity.name)}/)
    end
  end

  context '#approve_request_to_charity_admins' do
    it "should be set to be delivered to the charity's admins" do
      charity_admin = create :user
      charity = create :charity, leader: charity_admin
      charity_join_request = build(:approved_charity_join_request, charity: charity)

      email = CharityJoinRequestMailer.approve_request_to_charity_admins(charity_join_request)

      email.should deliver_to([charity_admin.email])
    end

    it "should contain the requester's name" do
      requester = build_stubbed :user
      charity_join_request = build(:approved_charity_join_request, user: requester)

      email = CharityJoinRequestMailer.approve_request_to_charity_admins(charity_join_request)

      email.should have_body_text(/#{requester.name}/)
    end

    it "should contain the admin's name" do
      admin = build_stubbed :user
      charity_join_request = build(:approved_charity_join_request, admin: admin)

      email = CharityJoinRequestMailer.approve_request_to_charity_admins(charity_join_request)

      email.should have_body_text(/#{admin.name}/)
    end

    it "should have the correct subject" do
      charity = build :charity
      email = CharityJoinRequestMailer.approve_request_to_charity_admins build_stubbed(:approved_charity_join_request, charity: charity)

      email.should have_subject(/#{I18n.t('mailer.charity_join_request_mailer.approve_request_to_charity_admins.subject', charity: charity.name)}/)
    end
  end

  context '#reject_request_to_requester' do
    it "should be set to be delivered to the requester" do
      requester = build_stubbed :user
      charity_join_request = build(:rejected_charity_join_request, user: requester)

      email = CharityJoinRequestMailer.reject_request_to_requester(charity_join_request)

      email.should deliver_to(requester.email)
    end

    it "should contain the requester's name" do
      requester = build_stubbed :user
      charity_join_request = build(:rejected_charity_join_request, user: requester)

      email = CharityJoinRequestMailer.reject_request_to_requester(charity_join_request)

      email.should have_body_text(/#{requester.name}/)
    end

    it "should have the correct subject" do
      charity = build :charity
      email = CharityJoinRequestMailer.reject_request_to_requester build_stubbed(:rejected_charity_join_request, charity: charity)

      email.should have_subject(/#{I18n.t('mailer.charity_join_request_mailer.reject_request_to_requester.subject', charity: charity.name)}/)
    end
  end
end
