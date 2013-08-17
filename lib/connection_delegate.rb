require 'json'

class ConnectionDelegate
  def connection(connection, didReceiveResponse:response)
    @response = response
    @downloadData = NSMutableData.data
  end

  def connection(connection, didReceiveData:data)
    @downloadData.appendData(data)
  end

  def connectionDidFinishLoading(connection)
    case @response.statusCode
    when 200...300
      responseBody = NSString.alloc.initWithData(@downloadData, encoding:NSUTF8StringEncoding)
      puts "Downloaded!"

      json = JSON.parse(responseBody)
      NSApplication.sharedApplication.delegate.menu.reDraw(json)
    when 300...400
      puts "TODO: Handle redirect!"
    else
      puts "Oh noes, an error occurred: #{@response.statusCode}"
    end
  end
end
