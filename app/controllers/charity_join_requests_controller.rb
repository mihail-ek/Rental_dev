class CharityJoinRequestsController < ApplicationController
  before_filter :authenticate_user!

  def new
    charity = Charity.where(number: flash[:charity_number]).first
    @charity_join_request = CharityJoinRequest.new(charity: charity)
  end

  def create
    @charity_join_request = CharityJoinRequest.new(charity_join_request_params)
    charity_join_request_handler = CharityJoinRequestHandler.new(@charity_join_request).create

    if charity_join_request_handler.persisted?
      CharityJoinRequestMailer.create_request(@charity_join_request).deliver

      charity = @charity_join_request.charity
      channel_name = WebsocketChannelHandler.generate_charity_join_request_channel(charity.id)
      WebsocketRails[channel_name].trigger("new_charity_join_request", charity.to_json)

      redirect_to my_home_path, notice: I18n.t('layouts.flash_messages.charity_join_request_sent')
    else
      render :new
    end
  end

  private
  def charity_join_request_params
    params[:charity_join_request].merge(user_id: current_user.id)
  end
end
