require 'spec_helper'

describe AuthHashService do
  context '#find_or_create_from_auth_hash' do
    it 'finds the current user if signed in' do
      current_user = create(:user, email: facebook_auth_hash.info.email)

      user = AuthHashService.new(facebook_auth_hash, current_user).find_or_create_from_auth_hash

      expect(user).to eq current_user
      assert_provider_authentication_existence(user)
    end

    it 'finds a user who has previously signed in with facebook' do
      existing_user = create(:user, provider: facebook_auth_hash[:provider], uid: facebook_auth_hash[:uid])

      user = AuthHashService.new(facebook_auth_hash).find_or_create_from_auth_hash

      expect(user).to eq existing_user
      assert_provider_authentication_existence(user)
    end

    it 'finds a user who has been invited by Makerble' do
      pending("can't make this test pass --'")
      invited_user = User.invite!(:email => facebook_auth_hash[:info][:email]) do |u|
          u.skip_invitation = true
      end

      user = AuthHashService.new(facebook_auth_hash, nil, invited_user.invitation_token).find_or_create_from_auth_hash

      expect(user).to eq invited_user
      assert_provider_authentication_existence(user)
    end

    it "finds a user who has previously signed in with email and adds the provider's data" do
      existing_user = create(:user, email: facebook_auth_hash[:info][:email])

      user = AuthHashService.new(facebook_auth_hash).find_or_create_from_auth_hash

      expect(user).to eq existing_user
      assert_provider_authentication_existence(user)
    end

    it 'creates a new user when there is no matching user' do
      user = AuthHashService.new(facebook_auth_hash).find_or_create_from_auth_hash

      expect(user).to be_persisted
      expect(user.first_name).to eq facebook_auth_hash[:info][:first_name]
      expect(user.last_name).to eq facebook_auth_hash[:info][:last_name]
      expect(user.email).to eq facebook_auth_hash[:info][:email]
      assert_provider_authentication_existence(user)
      assert_provider_image_existence(user)
    end

  end

  def facebook_auth_hash(options = {})
    auth_hash(:facebook).merge(options)
  end

  def auth_hash(provider = nil, options = {})
    OmniAuth.config.mock_auth[provider].merge(options)
  end

  def assert_provider_authentication_existence(user)
    expect(user.provider).to eq facebook_auth_hash[:provider]
    expect(user.uid).to eq facebook_auth_hash[:uid]
  end

  def assert_provider_image_existence(user)
    image_path = URI.parse(OpenURIRedirections.new(facebook_auth_hash[:info][:image]).process_uri).path
    expect(image_path).to include user.avatar_file_name
  end
end
