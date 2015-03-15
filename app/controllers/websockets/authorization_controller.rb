class Websockets::AuthorizationController < WebsocketRails::BaseController
  def authorize_channels
    channel_name = message[:channel]

    if WebsocketChannelHandler.is_charity_join_request_channel?(channel_name)
      charity_id = WebsocketChannelHandler.extract_id(channel_name)
      authorize_charity_join_request_channel(charity_id)
    else
      deny_channel
    end
  end

  private
  def authorize_charity_join_request_channel(charity_id)
    if current_user.charities_as_editor_ids.include? charity_id.to_i
      accept_channel
    else
      deny_channel
    end
  end
end
