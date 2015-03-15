require 'spec_helper'

describe Cause do
  it { should have_many(:sub_causes).dependent(:destroy) }

  it { should accept_nested_attributes_for(:sub_causes).allow_destroy(true) }

  context "#sub_cause_list" do
    it "returns a string containing sub causes delimited with commas" do
      cause = Cause.new()
      cause.sub_causes.build [{name: "tag1"}, {name: "tag2"}]

      expect(cause.sub_cause_list).to eq "tag1,tag2"
    end
  end
end

