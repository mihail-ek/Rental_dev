require 'spec_helper'

describe CharityJoinRequest do
  include_examples 'a requestable resource'

  it { should belong_to(:user) }
  it { should belong_to(:charity) }
  it { should belong_to(:admin).class_name('User').with_foreign_key('admin_id') }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:charity) }
  it { should validate_presence_of(:status) }
  it { should ensure_inclusion_of(:status).in_array(JoinRequestStatus.all) }
  it { should ensure_length_of(:message).is_at_most(300) }

  context '#add_member_to_charity' do
    it "add requester to the charity editors' list" do
      user = create :user
      charity = create :charity
      charity_join_request = CharityJoinRequest.new user: user, charity: charity

      charity_join_request.add_member_to_charity

      charity.reload.editors.should include user
    end
  end
end
