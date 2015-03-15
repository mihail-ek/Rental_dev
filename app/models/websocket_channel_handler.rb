class WebsocketChannelHandler
  CHANNELS = ["charity_join_request_channel"]

  def self.all_channels
    CHANNELS
  end

  CHANNELS.each do |channel|
    define_singleton_method("generate_#{channel}") do |id|
      channel.camelize(:lower) << "_#{id}"
    end

    define_singleton_method("is_#{channel}?") do |channel_name|
      channel.camelize(:lower) == extract_type(channel_name)
    end
  end

  def self.extract_type(channel_name)
    channel_name.split('_').first
  end

  def self.extract_id(channel_name)
    channel_name.split('_').last
  end
end
