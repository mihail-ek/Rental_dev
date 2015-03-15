require 'spec_helper'

describe Charity do
  context ".pending" do
    it "is pending approval when a document, HMRC number or Charity Regulator is not present" do
      charity = create(:charity)

      expect(Charity.pending).to include charity
    end

    it "is pending approval when all documents, HMRC number and Charity Regulator are present, and it is not public" do
      charity = create(:charity_ready_for_approval)

      expect(Charity.pending).to include charity
    end

    it "is not pending approval when all documents, HMRC number and Charity Regulator are present, and it is public" do
      charity = create(:charity_approved)

      expect(Charity.pending).not_to include charity
    end
  end

  context '#add_leader' do
    it "adds the passed in user as charity leader" do
      charity = Charity.new
      user = build_stubbed(:user)

      charity.add_leader user

      expect(charity.leader).to eq user
    end

    it "adds the passed in user as charity editor" do
      charity = Charity.new
      user = build_stubbed(:user)

      charity.add_leader user

      expect(charity.editors.first).to eq user
    end
  end

  context '#add_member' do
    it "adds the passed in user as charity member" do
      charity = Charity.new
      user = build_stubbed(:user)

      charity.add_member user

      expect(charity.editors.last).to eq user
    end
  end

  context '#leader' do
    it 'returns the assigned leader' do
      user = build_stubbed :user
      charity = build :charity, leader: user

      expect(charity.leader).to eq user
    end

    it "returns the first editor when there's no leader assigned" do
      user = build_stubbed :user
      charity = build :charity_without_leader, editor: user

      expect(charity.leader).to eq user
    end
  end
end
