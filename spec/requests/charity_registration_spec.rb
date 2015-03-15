require "spec_helper"

describe "Charity Registration" do
  context 'user is not signed in' do
    it 'arrives at the Personal Sign Up page' do
      get personal_sign_up_path
      expect(response).to be_success
    end

    it "redirects to Sign In page if user tries to sign in" do
      get new_charity_registration_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'user is signed in' do
    it 'redirects to Charity Registration page when arriving at Personal Sign Up page' do
      sign_in_user

      get personal_sign_up_path
      expect(response).to redirect_to(new_charity_registration_path)
    end
  end

  context "charity is not yet registered in the system" do
    it "submits the charity registration number and redirects to New Charity path" do
      sign_in_user

      charity_number = '12345'
      post charity_registrations_path, charity_number: charity_number
      expect(response).to redirect_to(new_charity_path)

      follow_redirect!
      expect(flash[:charity_number]).to eq charity_number
    end
  end

  context "charity is already registered in the system" do
    it "submits the charity registration number and redirects to Send Join Request path" do
      sign_in_user

      charity_number = '12345'
      create :charity, number: charity_number

      post charity_registrations_path, charity_number: charity_number
      expect(response).to redirect_to(new_charity_join_request_path)

      follow_redirect!
      expect(flash[:charity_number]).to eq charity_number
    end
  end
end

def sign_in_user
  password = 'password'
  user = create :user, password: password, password_confirmation: password
  post new_user_session_path, user: { email: user.email, password: password }
end
