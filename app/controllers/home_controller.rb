class HomeController < ApplicationController
  skip_filter :authenticate_user!
end
