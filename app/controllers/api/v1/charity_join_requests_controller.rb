class Api::V1::CharityJoinRequestsController < Api::ApplicationController
  skip_authorize_resource :only => [:pending, :approve, :reject]

  def pending
    charity_ids = current_user.charities_as_editor.map(&:id)
    @join_requests = CharityJoinRequest.where(charity_id: charity_ids).pending
    render :index
  end

  def approve
    @join_request = CharityJoinRequest.find(params[:id])
    charity_join_request_handler = CharityJoinRequestHandler.new(@join_request, current_user)
    if charity_join_request_handler.approve
      @join_request = CharityJoinRequest.find(params[:id])
      CharityJoinRequestMailer.approve_request_to_requester(@join_request).deliver
      CharityJoinRequestMailer.approve_request_to_charity_admins(@join_request).deliver

      charity = @join_request.charity
      channel_name = WebsocketChannelHandler.generate_charity_join_request_channel(charity.id)
      WebsocketRails[channel_name].trigger("charity_join_request_approved", charity.to_json)

      render :show
    else
      render json: false
    end
  end

  def reject
    @join_request = CharityJoinRequest.find(params[:id])
    charity_join_request_handler = CharityJoinRequestHandler.new(@join_request, current_user)
    if charity_join_request_handler.reject
      @join_request = CharityJoinRequest.find(params[:id])
      CharityJoinRequestMailer.reject_request_to_requester(@join_request).deliver

      render :show
    else
      render json: false
    end
  end
end
