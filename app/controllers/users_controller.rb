class UsersController < ApplicationController
  skip_filter :authenticate_user!, only: [:waiting_list, :skip_invitation_and_sign_up, :create_skipped_invitation]
  load_and_authorize_resource only: [:show, :edit, :update]

  def waiting_list
    if user_signed_in?
      redirect_to causes_preferences_causes_path
    elsif session[:skip_invitation].present? && session[:skip_invitation] == true
      redirect_to skip_invitation_and_sign_up_path
    end
  end

  def skip_invitation_and_sign_up
    unless session[:skip_invitation].present? && session[:skip_invitation] == true
      redirect_to root_path
    end
  end

  def create_skipped_invitation
    if !(session[:skip_invitation].present? && session[:skip_invitation] == true)
      redirect_to root_path
    elsif !params[:user].present? || !params[:user][:email].present? || (params[:user][:email] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).nil?
      redirect_to skip_invitation_and_sign_up_path, notice: 'Please make sure that your email address is valid.'
    else
      user = User.invite!(email: params[:user][:email]) do |u|
        u.skip_invitation = true
      end
      session[:skip_invitation] = nil
      redirect_to accept_invitation_url(user, :invitation_token => user.raw_invitation_token)
    end
  end

  def show
    @welcome_messages = []
    @is_following = user_signed_in? ? @user.followed_by?(current_user) : false
  end

  def edit
  end

  def update
    respond_to do |format|
      if (((params[:user][:current_password].nil? || params[:user][:current_password].empty?) &&
           (params[:user][:password].nil? || params[:user][:password].empty?) &&
           (params[:user][:password_confirmation].nil? || params[:user][:password_confirmation].empty?)) &&
           @user.update_without_password(params[:user])) ||
          (@user.update_with_password(params[:user]) && sign_in(@user, :bypass => true))
        format.html { redirect_to user_path(@user) }
      else
        format.html { render action: "edit" }
      end
    end
  end
end
