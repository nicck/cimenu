class AppDelegate
  attr_reader :trayMenu
  attr_accessor :preferencesWindow
  attr_accessor :tokenTextField
  attr_accessor :updater

  def applicationDidFinishLaunching(notification)
    puts 'applicationDidFinishLaunching'

    NSApp.setActivationPolicy(NSApplicationActivationPolicyProhibited)

    @trayMenu = TrayMenu.new(self)
    @trayMenu.reDraw

    @statusBar = StatusBar.new(self)
    @statusBar.trayMenu = @trayMenu

    @dataFetcher = DataFetcher.new(@statusBar)
    @dataFetcher.fetch
    @dataFetcher.startTimer
  end

  def checkForUpdates(sender)
    updater.checkForUpdates(sender)
  end

  def showAboutPanel(sender)
    NSApplication.sharedApplication.orderFrontStandardAboutPanel(sender)
    NSApp.arrangeInFront(sender)
  end

  def quit(notification)
    puts 'Bye!'
    exit
  end

  def showPreferences(sender)
    tokenTextField.stringValue = apiKey unless apiKey.nil?
    NSApp.setActivationPolicy(NSApplicationActivationPolicyRegular)
    NSApp.activateIgnoringOtherApps(true)
    preferencesWindow.makeKeyAndOrderFront(nil)
  end

  def windowWillClose(notification)
    NSApp.setActivationPolicy(NSApplicationActivationPolicyProhibited)
  end

  def openBuild(menuItem)
    url = NSURL.URLWithString(menuItem.url)
    NSWorkspace.sharedWorkspace.openURL(url)
  end

  def controlTextDidChange(notification)
    value = notification.object.stringValue

    if value.length == 20
      p "controlTextDidChange and length is 20: #{value}"
      self.apiKey = value
      @dataFetcher.fetch
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
