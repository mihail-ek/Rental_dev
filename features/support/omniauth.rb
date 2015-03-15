Before('@omniauth_test') do
  OmniAuth.config.test_mode = true

  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '123545',
    'info' => {
      'email' => 'guest@example.com',
      'name' => 'John Doe',
      'first_name' => 'John',
      'last_name' => 'Doe',
      'image' => 'http://graph.facebook.com/123545/picture?type=square'
    }
  })
end

After('@omniauth_test') do
  OmniAuth.config.test_mode = false
end
