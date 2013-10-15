class DataFetcher
  URL = "https://semaphoreapp.com/api/v1/projects?auth_token="
  INTERVAL = 15

  def initialize(statusBar)
    @statusBar = statusBar
  end

  def fetch(timer = nil)
    request = NSMutableURLRequest.requestWithURL(url)

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

  private

  def apiKey
    defaults = NSUserDefaults.standardUserDefaults
    token = defaults.objectForKey 'org.cimenu.apikey'
    p "fetching with #{token}"
    token
  end

  def url
    NSURL.URLWithString("#{URL}#{apiKey}")
  end
end
