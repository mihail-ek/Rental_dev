require 'spec_helper'

describe SubCause do
  it { should belong_to(:cause) }
  it { should have_and_belong_to_many(:projects) }

  it { should validate_presence_of(:cause) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name).scoped_to(:cause_id) }
end
