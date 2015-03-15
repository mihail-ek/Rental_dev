require 'spec_helper'

describe CharityJoinRequestsController do
  login_user

  context 'POST /create' do
    it 'assigns @charity_join_request' do
      charity = create :charity

      post :create, charity_join_request: { charity_id: charity.id, message: nil }

      expect(assigns(:charity_join_request)).to be
    end

    it 'creates an email and sends it if the charity join request is valid' do
      charity_admin = create :user
      charity = create :charity, leader: charity_admin

      CharityJoinRequestMailer.should_receive(:create_request).with(an_instance_of(CharityJoinRequest)).and_call_original

      post :create, charity_join_request: { charity_id: charity.id, message: '' }

      expect(ActionMailer::Base.deliveries.last.to).to include charity_admin.email
    end

    it 'redirects to My Home page' do
      charity = create :charity
      message = "something"

      post :create, charity_join_request: { charity_id: charity.id, message: message }

      expect(response).to redirect_to my_home_path
    end

    it 'sends live notification to any signed in Charity Admin' do
      charity = create :charity

      channel_name = WebsocketChannelHandler.generate_charity_join_request_channel(charity.id)
      WebsocketRails[channel_name].should_receive(:trigger).with("new_charity_join_request", charity.to_json)

      post :create, charity_join_request: { charity_id: charity.id, message: '' }
    end
  end
end
