require 'json'

class ConnectionDelegate
  def initialize(statusBar)
    @statusBar = statusBar
    @statusBar.startAnimation
  end

  def connection(connection, didReceiveResponse:response)
    @response = response
    @downloadData = NSMutableData.data
  end

  def connection(connection, didReceiveData:data)
    @downloadData.appendData(data)
  end

  def connectionDidFinishLoading(connection)
    @statusBar.stopAnimation

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

      # TODO: try https://github.com/Simbul/semaphoreapp
      @statusBar.trayMenu.reDraw(json)
      # @statusBar.updateIconWithData(json)

    when 300...400
      puts "TODO: Handle redirect!"
    else
      @statusBar.image = @statusBar.iconOffline
      puts "Oh noes, an error occurred: #{@response.statusCode}"
    end
  end
end
