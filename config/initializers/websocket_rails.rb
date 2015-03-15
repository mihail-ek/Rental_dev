WebsocketRails.setup do |config|
  config.standalone = false

  config.synchronize = false

  # By default, all subscribers in to a channel will be removed
  # when that channel is made private. If you don't wish active
  # subscribers to be removed from a previously public channel
  # when making it private, set the following to true.
  # config.keep_subscribers_when_private = false

  # Set to true if you wish to broadcast channel subscriber_join and
  # subscriber_part events. All subscribers of a channel will be
  # notified when other clients join and part the channel. If you are
  # using the UserManager, the current_user object will be sent along
  # with the event.
  # config.broadcast_subscriber_events = true

  # Used as the key for the WebsocketRails.users Hash. This method
  # will be called on the `current_user` object in your controller
  # if one exists. If `current_user` does not exist or does not
  # respond to the identifier, the key will default to `connection.id`
  # config.user_identifier = :id

  # Uncomment and change this option to override the class associated
  # with your `current_user` object. This class will be used when
  # synchronization is enabled and you trigger events from background
  # jobs using the WebsocketRails.users UserManager.
  # config.user_class = User

  # Supporting HTTP streaming on Internet Explorer versions 8 & 9
  # requires CORS to be enabled for GET "/websocket" request.
  # List here the origin domains allowed to perform the request.
  # config.allowed_origins = ['http://localhost:3000']
end
