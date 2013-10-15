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
    tokenTextField.stringValue = readApiKey
    preferencesWindow.makeKeyAndOrderFront(self)
  end

  def controlTextDidChange(notification)
    value = notification.object.stringValue
    p "controlTextDidChange: #{value}"
    saveApiKey(value)
  end

  def menuWillOpen(notification)
    @statusBar.menuWillOpen
  end

  def menuDidClose(notification)
    @statusBar.menuDidClose
  end

  private

  def saveApiKey(apiKey)
    defaults = NSUserDefaults.standardUserDefaults
    defaults.setObject(apiKey, forKey: 'org.cimenu.apikey')
    defaults.synchronize
  end

  def readApiKey
    defaults = NSUserDefaults.standardUserDefaults
    defaults.objectForKey('org.cimenu.apikey')
  end
end
