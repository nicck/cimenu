class AppDelegate
  attr_reader :trayMenu
  attr_accessor :preferencesWindow
  attr_accessor :tokenTextField

  def applicationDidFinishLaunching(notification)
    puts 'applicationDidFinishLaunching'

    @trayMenu = TrayMenu.new(self)
    @trayMenu.reDraw

    @statusBar = StatusBar.new(self)
    @statusBar.trayMenu = @trayMenu

    dataFetcher = DataFetcher.new(@statusBar)
    dataFetcher.fetch
    dataFetcher.startTimer
  end

  def quit(notification)
    puts 'Bye!'
    exit
  end

  def showPreferences(notification)
    tokenTextField.stringValue = apiKey
    preferencesWindow.makeKeyAndOrderFront(self)
  end

  def controlTextDidChange(notification)
    value = notification.object.stringValue

    if value.length == 20
      p "controlTextDidChange and length is 20: #{value}"
      self.apiKey = value
    end
  end

  def menuWillOpen(notification)
    @statusBar.menuWillOpen
  end

  def menuDidClose(notification)
    @statusBar.menuDidClose
  end

  private

  def apiKey=(token)
    defaults = NSUserDefaults.standardUserDefaults
    # defaults.setObject(token, forKey: 'org.cimenu.apikey')
    defaults['org.cimenu.apikey'] = token
    defaults.synchronize
  end

  def apiKey
    defaults = NSUserDefaults.standardUserDefaults
    # defaults.objectForKey('org.cimenu.apikey')
    defaults['org.cimenu.apikey']
  end
end
