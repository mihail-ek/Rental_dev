OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
  :provider => 'facebook',
  :uid => '12345',
  'info' => {
    'email' => 'guest@example.com',
    'name' => 'John Doe',
    'first_name' => 'John',
    'last_name' => 'Doe',
    'image' => 'http://graph.facebook.com/12345/picture?type=square'
  }
})
