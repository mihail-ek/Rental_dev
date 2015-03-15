require 'spec_helper'

describe WebsocketChannelHandler do
  context ".generate_charity_join_request_channel" do
    it "generates a channel name concatenated with the passed in 'id'" do
      id = 2
      channel_name = WebsocketChannelHandler.generate_charity_join_request_channel(id)

      expect(channel_name).to eq "charityJoinRequestChannel_#{id}"
    end
  end

  context ".is_charity_join_request_channel?" do
    it "returns true if the passed in channel is a charity join request channel" do
      channel_name = "charityJoinRequestChannel_1"

      answer = WebsocketChannelHandler.is_charity_join_request_channel?(channel_name)

      expect(answer).to be
    end
  end

  context ".extract_type" do
    it "returns the channel's type" do
      channel_type = "charityJoinRequestChannel"
      id = "1"
      channel_name = "#{channel_type}_#{id}"

      type = WebsocketChannelHandler.extract_type(channel_name)

      expect(type).to eq channel_type
    end
  end

  context ".extract_id" do
    it "returns the charity's id" do
      channel_type = "charityJoinRequestChannel"
      charity_id = "1"
      channel_name = "#{channel_type}_#{charity_id}"

      id = WebsocketChannelHandler.extract_id(channel_name)

      expect(id).to eq charity_id
    end
  end
end
