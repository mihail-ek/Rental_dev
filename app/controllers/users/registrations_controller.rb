class Users::RegistrationsController < Devise::RegistrationsController
  def create
    @redirect_to_path = params[:redirect_to_path] if params[:redirect_to_path]
    super
  end

  protected
  attr_reader :redirect_to_path

  def after_sign_up_path_for(resource)
    @redirect_to_path.presence || super
  end
end
