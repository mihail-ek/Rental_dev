class WelcomeMessagesController < ApplicationController
  before_filter :authenticate_user!
  load_resource :welcome_message, only: [:show, :destroy]
  authorize_resource
end
