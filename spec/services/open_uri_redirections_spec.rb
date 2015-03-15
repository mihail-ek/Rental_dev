require 'spec_helper'

describe OpenURIRedirections do
  it 'allows redirections from HTTP to HTTPS' do
    image = 'http://graph.facebook.com/1234567/picture?type=square'

    expect(OpenURIRedirections.new(image).process_uri).to match /https.*/
  end
end
