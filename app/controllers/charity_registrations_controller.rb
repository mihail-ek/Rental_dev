class CharityRegistrationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    charity_number = params[:charity_number]
    if Charity.find_by_number(charity_number)
      redirect_to new_charity_join_request_path, flash: { charity_number: charity_number }
    else
      redirect_to new_charity_path, flash: { charity_number: charity_number }
    end
  end
end
