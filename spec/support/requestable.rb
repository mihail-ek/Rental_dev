shared_examples 'a requestable resource' do
  let(:resource) { create(described_class.to_s.underscore) }

  JoinRequestStatus.all.each do |state|
    context "#make_#{state}" do
      it "sets the resource's state to #{state}" do
        resource.send(:"make_#{state}")

        resource.should send("be_#{state}")
      end
    end
  end

  context 'on initialization' do
    it 'is pending by default' do
      resource.should be_pending
    end
  end
end
