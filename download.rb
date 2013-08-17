class Download
  attr_reader :response, :responseBody, :json

  def start(request)
    puts "START!"
    NSURLConnection.connectionWithRequest(request, delegate:self)
  end

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
      json = JSON.parse(responseBody)
      puts "Downloaded: #{responseBody}"
      NSApplication.sharedApplication.delegate.reDrawMenu(json)
    when 300...400
      puts "TODO: Handle redirect!"
    else
      puts "Oh noes, an error occurred: #{@response.statusCode}"
    end
  end
end
