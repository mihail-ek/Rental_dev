class Users::SessionsController < Devise::SessionsController
  def new
    if session[:skip_invitation].present? && session[:skip_invitation] == true
      redirect_to skip_invitation_and_sign_up_path
    end
  end
end
