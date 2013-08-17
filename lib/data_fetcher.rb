require 'lib/connection_delegate'

AUTH_TOKEN = ENV['SEM_AUTH_TOKEN']

class DataFetcher
  INTERVAL = 15

  def initialize(statusBar)
    @statusBar = statusBar
    @url = "https://semaphoreapp.com/api/v1/projects?auth_token=#{AUTH_TOKEN}"
  end

  def fetch(timer = nil)
    p 'fetching'
    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(@url))
    NSURLConnection.connectionWithRequest(request,
      delegate:ConnectionDelegate.new(@statusBar))
  end

  def startTimer
    @timer = NSTimer.scheduledTimerWithTimeInterval INTERVAL,
      target:self,
      selector:'fetch:',
      userInfo:nil,
      repeats:true
  end

  def stopTimer
    @timer.invalidate && @timer = nil if @timer
  end
end
