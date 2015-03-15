class WaitingListsController < ApplicationController
  skip_filter :authenticate_user!, only: :create
  load_and_authorize_resource

  def grant_access
    @waiting_list = WaitingList.find(params[:waiting_list][:email])
    if @waiting_list
      email = @waiting_list.email
      User.waiting_list_invite!(email: email)
      WaitingList.where(email: email).each do |waiting_list|
        waiting_list.destroy
      end
      redirect_to :back, notice: "#{email}'s owner will receive a mail shortly."
    else
      redirect_to :back, notice: "An error prevents us from sending the invitation. Did you select an email address?"
    end
  end

  def create
    respond_to do |format|
      if @waiting_list.save
        DeviseMailer.delay.registration_on_the_waiting_list(@waiting_list.email)
        format.html { redirect_to root_path, notice: "Congratulations! You've now registered on the waiting list for access to Makerble." }
      else
        format.html { redirect_to :back, notice: "Please make sure your email address is valid." }
      end
    end
  end
end
