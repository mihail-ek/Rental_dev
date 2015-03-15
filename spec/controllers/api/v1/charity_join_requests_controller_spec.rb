require 'spec_helper'

describe Api::V1::CharityJoinRequestsController do
  render_views

  before do
    controller.stub(:authorize!).and_return(true)
    controller.stub(:authenticate_user!).and_return(true)
    controller.stub(:current_user).and_return(build_stubbed :user)
  end

  describe "GET pending" do
    it "assigns @join_requests" do
      join_requests = [build_stubbed(:charity_join_request)]
      CharityJoinRequest.stub(:pending).and_return(join_requests)

      xhr :get, :pending, { format: :json }

      expect(assigns(:join_requests)).to eq join_requests
    end

    it "renders @join_requests in JSON" do
      join_requests = create_list :charity_join_request, 2
      CharityJoinRequest.stub(:pending).and_return(join_requests)

      xhr :get, :pending, { format: :json }

      rendered = JSON.parse Rabl.render(join_requests, 'api/v1/charity_join_requests/index.json', :view_path => 'app/views')
      expect(JSON.parse(response.body)).to eq rendered
    end
  end

  describe "POST approve" do
    it 'approves the join request' do
      charity_join_request = build_stubbed :charity_join_request
      CharityJoinRequest.stub(:find).and_return(charity_join_request)
      charity_join_request_handler = double CharityJoinRequestHandler, approve: false
      CharityJoinRequestHandler.stub(:new).and_return charity_join_request_handler

      charity_join_request_handler.should_receive :approve

      xhr :post, :approve, { id: '', format: :json }
    end

    it 'creates an email and sends it to the requester if the charity join request was successfully approved' do
      charity_join_request = create :charity_join_request, admin: build_stubbed(:user)
      CharityJoinRequest.stub(:find).and_return(charity_join_request)
      charity_join_request_handler = double CharityJoinRequestHandler, approve: true
      CharityJoinRequestHandler.stub(:new).and_return charity_join_request_handler

      CharityJoinRequestMailer.should_receive(:approve_request_to_requester).with(an_instance_of(CharityJoinRequest)).and_call_original

      xhr :post, :approve, { id: '', format: :json }

      expect(ActionMailer::Base.deliveries[-2].to).to include charity_join_request.user.email
    end

    it 'creates an email and sends it to all charity admins if the charity join request was successfully approved' do
      charity_join_request = create :charity_join_request, admin: build_stubbed(:user)
      CharityJoinRequest.stub(:find).and_return(charity_join_request)
      charity_join_request_handler = double CharityJoinRequestHandler, approve: true
      CharityJoinRequestHandler.stub(:new).and_return charity_join_request_handler

      CharityJoinRequestMailer.should_receive(:approve_request_to_charity_admins).with(an_instance_of(CharityJoinRequest)).and_call_original

      xhr :post, :approve, { id: '', format: :json }

      expect(ActionMailer::Base.deliveries.last.to).to eq charity_join_request.charity.editors.pluck(:email)
    end

    it "responds with the request's object if everything goes well" do
      charity_join_request = create :charity_join_request, admin: build_stubbed(:user)
      CharityJoinRequest.stub(:find).and_return(charity_join_request)
      charity_join_request_handler = double CharityJoinRequestHandler, approve: true
      CharityJoinRequestHandler.stub(:new).and_return charity_join_request_handler
      rendered = JSON.parse Rabl.render(charity_join_request, 'api/v1/charity_join_requests/show.json', :view_path => 'app/views')

      xhr :post, :approve, { id: '', format: :json }

      expect(JSON.parse(response.body)).to eq rendered
    end

    it 'sends live notification to any signed in Charity Admin' do
      charity_join_request = create :charity_join_request, admin: build_stubbed(:user)
      CharityJoinRequest.stub(:find).and_return(charity_join_request)
      charity_join_request_handler = double CharityJoinRequestHandler, approve: true
      CharityJoinRequestHandler.stub(:new).and_return charity_join_request_handler
      charity = charity_join_request.charity

      channel_name = WebsocketChannelHandler.generate_charity_join_request_channel(charity.id)
      WebsocketRails[channel_name].should_receive(:trigger).with("charity_join_request_approved", charity.to_json)

      xhr :post, :approve, { id: '', format: :json }
    end
  end

  describe "POST reject" do
    it 'rejects the join request' do
      charity_join_request = build_stubbed :charity_join_request
      CharityJoinRequest.stub(:find).and_return(charity_join_request)
      charity_join_request_handler = double CharityJoinRequestHandler, reject: false
      CharityJoinRequestHandler.stub(:new).and_return charity_join_request_handler

      charity_join_request_handler.should_receive :reject

      xhr :post, :reject, { id: '', format: :json }
    end

    it 'creates an email and sends it to the requester if the charity join request was successfully rejected' do
      charity_join_request = create :charity_join_request, admin: build_stubbed(:user)
      CharityJoinRequest.stub(:find).and_return(charity_join_request)
      charity_join_request_handler = double CharityJoinRequestHandler, reject: true
      CharityJoinRequestHandler.stub(:new).and_return charity_join_request_handler

      CharityJoinRequestMailer.should_receive(:reject_request_to_requester).with(an_instance_of(CharityJoinRequest)).and_call_original

      xhr :post, :reject, { id: '', format: :json }

      expect(ActionMailer::Base.deliveries.last.to).to include charity_join_request.user.email
    end

    it "responds with request's object if everything goes well" do
      charity_join_request = create :charity_join_request, admin: build_stubbed(:user)
      CharityJoinRequest.stub(:find).and_return(charity_join_request)
      charity_join_request_handler = double CharityJoinRequestHandler, reject: true
      CharityJoinRequestHandler.stub(:new).and_return charity_join_request_handler
      rendered = JSON.parse Rabl.render(charity_join_request, 'api/v1/charity_join_requests/show.json', :view_path => 'app/views')

      xhr :post, :reject, { id: '', format: :json }

      expect(JSON.parse(response.body)).to eq rendered
    end
  end
end
