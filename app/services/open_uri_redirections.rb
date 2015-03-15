require 'open-uri'
require 'open_uri_redirections'

class OpenURIRedirections
  def initialize(uri = nil)
    @uri = uri
  end

  def process_uri
    open(@uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end

  private
    attr_reader :uri
end
