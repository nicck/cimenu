require 'json'

class ConnectionDelegate
  def initialize
    NSNotificationCenter.defaultCenter.postNotificationName(
      "com.cimenu.CIMenu.semaphore.connectionWillStartLoading",
      object:nil)
  end

  def connection(connection, didReceiveResponse:response)
    @response = response
    @downloadData = NSMutableData.data
  end

  def connection(connection, didReceiveData:data)
    @downloadData.appendData(data)
  end

  def connectionDidFinishLoading(connection)
    NSNotificationCenter.defaultCenter.postNotificationName(
      "com.cimenu.CIMenu.semaphore.connectionDidFinishLoading",
      object:nil)

    case @response.statusCode
    when 200...300
      responseBody = NSString.alloc.initWithData @downloadData,
        encoding:NSUTF8StringEncoding

      begin
        json = JSON.parse(responseBody)
      rescue Exception
        NSApplication.sharedApplication.delegate.showPreferences(nil)
        return
      end

      NSNotificationCenter.defaultCenter.postNotificationName(
        "com.cimenu.CIMenu.semaphore.dataReceived",
        object:nil,
        userInfo:json)

    when 300...400
      puts "TODO: Handle redirect!"
    else
      # @statusBar.image = @statusBar.iconOffline
      puts "Oh noes, an error occurred: #{@response.statusCode}"
    end
  end
end
