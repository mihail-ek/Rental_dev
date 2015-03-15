class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth_hash_service = AuthHashService.new(auth_hash, current_user, session[:invitation_token])
    @user = auth_hash_service.find_or_create_from_auth_hash
    session[:invitation_token] = nil
    handle_user "Facebook"
  end

  def twitter
    auth_hash_service = AuthHashService.new(auth_hash, current_user)
    @user = auth_hash_service.find_or_create_from_auth_hash
    handle_user "Twitter"
  end

  private
    def handle_user kind
      if @user.persisted?
        handle_persisted_user(kind)
      else
        handle_not_persisted_user(kind)
      end
    end

    def handle_persisted_user(kind)
      # OmniAuth requests save the original URL in 'omniauth.origin'
      # Changes the default after_sign_in_path_for when the request originates from "/personal-sign-up"
      if request.env['omniauth.origin'] == personal_sign_up_url
        session[:return_to_url] = request.env['omniauth.origin']
      end

      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => kind) if is_navigational_format?
    end

    def handle_not_persisted_user(kind)
      if kind == "Facebook"
        session["devise.facebook_data"] = request.env["omniauth.auth"]
      elsif kind == "Twitter"
        session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      end
      redirect_to new_user_registration_url
    end

    def auth_hash
      request.env['omniauth.auth']
    end
end
