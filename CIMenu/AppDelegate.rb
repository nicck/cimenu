class AppDelegate
  attr_reader :trayMenu
  attr_accessor :preferencesWindow
  attr_accessor :tokenTextField
  attr_accessor :updater

  def applicationDidFinishLaunching(notification)
    puts 'applicationDidFinishLaunching'

    NSApp.setActivationPolicy(NSApplicationActivationPolicyProhibited)

    @trayMenu = TrayMenu.new(self)

    @statusBar = StatusBar.new(self, @trayMenu)

    NSNotificationCenter.defaultCenter.addObserver(self,
      selector:"dataReceived:",
      name:"com.cimenu.CIMenu.data.received",
      object:nil)

    NSNotificationCenter.defaultCenter.addObserver(self,
       selector:"dataFetching:",
       name:"com.cimenu.CIMenu.data.fetching",
       object:nil)

    NSNotificationCenter.defaultCenter.addObserver(self,
       selector:"dataDone:",
       name:"com.cimenu.CIMenu.data.done",
       object:nil)

    @dataFetcher = DataFetcher.new
    @dataFetcher.fetch
    @dataFetcher.startTimer
  end

  def dataFetching(notification)
    @statusBar.startAnimation
  end

  def dataDone(notification)
    @statusBar.stopAnimation
  end

  def dataReceived(notification)
    # TODO: try https://github.com/Simbul/semaphoreapp
    json = notification.userInfo
    @statusBar.trayMenu.reDraw(json)
  end

  # from TrayMenu (via target action)
  def checkForUpdates(sender)
    updater.checkForUpdates(sender)
  end

  # from TrayMenu (via target action)
  def showAboutPanel(sender)
    NSApplication.sharedApplication.orderFrontStandardAboutPanel(sender)
    NSApp.arrangeInFront(sender)
  end

  # from TrayMenu (via target action)
  def quit(notification)
    puts 'Bye!'
    exit
  end

  # from TrayMenu (via target action)
  def showPreferences(sender)
    tokenTextField.stringValue = apiKey unless apiKey.nil?
    NSApp.setActivationPolicy(NSApplicationActivationPolicyRegular)
    NSApp.activateIgnoringOtherApps(true)
    preferencesWindow.makeKeyAndOrderFront(nil)
  end

  # from preferencesWindow (via delegate)
  def windowWillClose(notification)
    NSApp.setActivationPolicy(NSApplicationActivationPolicyProhibited)
  end

  # from TrayMenu (via target action)
  def openBuild(menuItem)
    url = NSURL.URLWithString(menuItem.url)
    NSWorkspace.sharedWorkspace.openURL(url)
  end

  # from preferencesWindow Text Field (via delegate)
  def controlTextDidChange(notification)
    value = notification.object.stringValue

    if value.length == 20
      p "controlTextDidChange and length is 20: #{value}"
      self.apiKey = value
      @dataFetcher.fetch
    end
  end

  # from TrayMenu (via delegate)
  def menuWillOpen(notification)
    @statusBar.menuWillOpen
  end

  # from TrayMenu (via delegate)
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
