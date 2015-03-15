require 'spec_helper'

describe 'Event Mapping for Makerble' do
  describe 'websocket_rails.subscribe_private' do
    it 'should be routed correctly' do
      create_event('websocket_rails.subscribe_private', nil).should be_routed_only_to({ to: Websockets::AuthorizationController, with_method: :authorize_channels})
    end
  end
end
