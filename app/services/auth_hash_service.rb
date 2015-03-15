class AuthHashService
  def initialize(auth_hash, signed_in_resource = nil, invitation_token = nil)
    @auth_hash = auth_hash
    @signed_in_resource = signed_in_resource
    @invitation_token = invitation_token
  end

  def find_or_create_from_auth_hash
    user = find_from_auth_hash || create_from_auth_hash
    user = add_provider_authentication(user) if !user.uid.present?
    user
  end

  private
  attr_reader :auth_hash, :signed_in_resource, :invitation_token

  def find_from_auth_hash
    if @signed_in_resource
      user = @signed_in_resource
    else
      user = User.where(provider: @auth_hash.provider, uid: @auth_hash.uid).first
    end
  end

  def create_from_auth_hash
    if @invitation_token
      user = User.accept_invitation!(invitation_token: @invitation_token,
                                     password: Devise.friendly_token[0,20],
                                     first_name: @auth_hash.info.first_name,
                                     last_name: @auth_hash.info.last_name)
      user.avatar = URI.parse(OpenURIRedirections.new(@auth_hash.info.image).process_uri)
      user.save
    else
      user = User.find_by_email(@auth_hash.info.email)
      unless user
        user = User.create(first_name: @auth_hash.info.first_name,
                           last_name: @auth_hash.info.last_name,
                           email: @auth_hash.info.email,
                           password: Devise.friendly_token[0,20]
                           )
      end
    end

    user
  end

  def add_provider_authentication(user)
    user.provider = @auth_hash.provider
    user.uid = @auth_hash.uid
    user.avatar = URI.parse(OpenURIRedirections.new(@auth_hash.info.image).process_uri)
    user.save
    user
  end
end
