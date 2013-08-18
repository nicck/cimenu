require 'lib/connection_delegate'

class DataFetcher
  INTERVAL = 15

  def initialize(statusBar)
    @statusBar = statusBar
    @url = "https://semaphoreapp.com/api/v1/projects?auth_token="
  end

  def fetch(timer = nil)
    defaults = NSUserDefaults.standardUserDefaults
    api_key = defaults.objectForKey('org.cimenu.apikey')

    p "fetching with #{api_key}"
    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString("#{@url}#{api_key}"))
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
