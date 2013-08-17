require 'lib/connection_delegate'

AUTH_TOKEN = ENV['SEM_AUTH_TOKEN']

class DataFetcher
  def initialize(statusBar)
    @statusBar = statusBar
    @url = "https://semaphoreapp.com/api/v1/projects?auth_token=#{AUTH_TOKEN}"
  end

  def fetch
    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(@url))

    NSURLConnection.connectionWithRequest(request,
      delegate:ConnectionDelegate.new(@statusBar))
  end

  def start
    fetch
  end
end
