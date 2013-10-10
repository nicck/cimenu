class AppDelegate
  attr_reader :trayMenu
  attr_accessor :preferencesWindow

  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    @trayMenu = TrayMenu.new(self)
    @trayMenu.reDraw

    statusBar.trayMenu = @trayMenu

    dataFetcher = DataFetcher.new(statusBar)
    dataFetcher.fetch
    dataFetcher.startTimer
  end

  def quit(notification)
    puts 'Bye!'
    exit
  end

  def showPreferences(notification)
    preferencesWindow.makeKeyAndOrderFront(self)
  end

  def controlTextDidChange(notification)
    value = notification.object.stringValue
    p "controlTextDidChange: " << value
    saveApiKey value
  end

#  def controlTextDidEndEditing(notification)
#    p "controlTextDidEndEditing: " << notification.object.stringValue
#  end

  def menuWillOpen(notification)
    statusBar.menuWillOpen
  end

  def menuDidClose(notification)
    statusBar.menuDidClose
  end

  private

  def saveApiKey(apiKey)
    defaults = NSUserDefaults.standardUserDefaults
    defaults.setObject(apiKey, forKey: 'org.cimenu.apikey')
    defaults.synchronize
  end

  def statusBar
    @statusBar ||= StatusBar.new(self)
  end
end
