class CausesController < ApplicationController
  load_and_authorize_resource only: :show

  def show
    # do something
  end
end
