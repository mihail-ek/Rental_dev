require 'spec_helper'

describe CharityJoinRequestHandler do
  context '#create' do
    it 'creates a join request from the current user to the specified charity' do
      charity = create(:charity)
      charity_join_request = build(:charity_join_request, charity: charity)
      handler = CharityJoinRequestHandler.new(charity_join_request)

      join_request = handler.create

      expect(join_request).to be_persisted
      expect(join_request).to be_pending
    end
  end

  context '#approve' do
    it 'returns true if all goes well' do
      admin = build_stubbed :user
      charity_join_request = double 'CharityJoinRequest', make_approved: true, :admin= => admin, add_member_to_charity: true, save: true
      handler = CharityJoinRequestHandler.new(charity_join_request, admin)

      expect(handler.approve).to be
    end

    it 'changes the request status to approved' do
      admin = build_stubbed :user
      charity_join_request = double 'CharityJoinRequest', make_approved: false
      handler = CharityJoinRequestHandler.new(charity_join_request, admin)

      charity_join_request.should_receive :make_approved

      handler.approve
    end

    it 'assigns the admin who approved the request' do
      admin = build_stubbed :user
      charity_join_request = double 'CharityJoinRequest', make_approved: true, :admin= => admin, add_member_to_charity: true, save: true
      handler = CharityJoinRequestHandler.new(charity_join_request, admin)

      charity_join_request.should_receive(:admin=).with(admin)

      handler.approve
    end

    it 'makes the requester a member of the charity' do
      admin = build_stubbed :user
      charity_join_request = double 'CharityJoinRequest', make_approved: true, :admin= => admin, add_member_to_charity: true, save: true
      handler = CharityJoinRequestHandler.new(charity_join_request, admin)

      charity_join_request.should_receive(:add_member_to_charity)

      handler.approve
    end
  end

  context '#reject' do
    it 'returns true if all goes well' do
      admin = build_stubbed :user
      charity_join_request = double 'CharityJoinRequest', make_rejected: true, :admin= => admin, save: true
      handler = CharityJoinRequestHandler.new(charity_join_request, admin)

      expect(handler.reject).to be
    end

    it 'changes the request status to rejected' do
      admin = build_stubbed :user
      charity_join_request = double 'CharityJoinRequest', make_rejected: false
      handler = CharityJoinRequestHandler.new(charity_join_request, admin)

      charity_join_request.should_receive :make_rejected

      handler.reject
    end

    it 'assigns the admin who rejected the request' do
      admin = build_stubbed :user
      charity_join_request = double 'CharityJoinRequest', make_rejected: true, :admin= => admin, save: true
      handler = CharityJoinRequestHandler.new(charity_join_request, admin)

      charity_join_request.should_receive(:admin=).with(admin)

      handler.reject
    end
  end
end
