class Api::ApplicationController < ApplicationController
  load_and_authorize_resource
  layout "api_v1.json"
end
