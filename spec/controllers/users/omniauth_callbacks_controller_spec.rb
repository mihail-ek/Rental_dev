require 'spec_helper'

describe Users::OmniauthCallbacksController, "handles omniauth authentication callback" do
  describe "#facebook" do
    it 'assigns a user' do
      set_env_variables(:facebook)

      get :facebook
      expect(assigns(:user)).to be
    end

    it 'signs in the user' do
      set_env_variables(:facebook)

      get :facebook

      subject.should be_user_signed_in
    end

    context "sign in happens from the Personal Sign Up page" do
      it 'redirects to the Personal Sign Up page again' do
        set_env_variables(:facebook)
        request.env["omniauth.origin"] = personal_sign_up_url

        get :facebook
        response.should redirect_to personal_sign_up_path
      end
    end

    context "sign in happens from any other page" do
      it 'redirects to the home page' do
        set_env_variables(:facebook)

        get :facebook
        response.should redirect_to root_path
      end
    end
  end
end

def set_env_variables(provider)
  request.env["devise.mapping"] = Devise.mappings[:user]
  request.env["omniauth.auth"] = auth_hash(provider)
end

def auth_hash(provider = nil, options = {})
  OmniAuth.config.mock_auth[provider].merge(options)
end
