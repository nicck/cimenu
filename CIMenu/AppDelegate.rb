class AppDelegate
  def applicationWillFinishLaunching(notification)
    @statusBarItemController = StatusBarItemController.new

    icon_off = NSImage.imageNamed 'gear_offline.png'
    icon_inv = NSImage.imageNamed 'gear_clicked.png'

    @statusBarItemController.image = icon_off
    @statusBarItemController.alternateImage = icon_inv

    @statusBarItemController.menuIsActive = false
    @statusBarItemController.showImage
  end

  attr_reader :trayMenu
  attr_accessor :preferencesWindow
  attr_accessor :tokenTextField
  attr_accessor :loginStartup
  attr_accessor :updater

  def applicationDidFinishLaunching(notification)
    # statusBarMenuController = StatusBarMenuController.new
    # mainMenu = statusBarMenuController.mainMenu
    # @statusBarItemController.statusBarItemMenu = mainMenu

    puts 'applicationDidFinishLaunching'

    @trayMenu = TrayMenu.new(self)

    @statusBarItemController.statusBarItemMenu = @trayMenu

    @dataFetcher = DataFetcher.new
    @dataFetcher.fetch
    @dataFetcher.startTimer

    NSNotificationCenter.defaultCenter.addObserver(self,
      selector:"dataParseFailed:",
      name:"com.cimenu.CIMenu.semaphore.dataParseFailed",
      object:nil)
  end

  def dataParseFailed(notification)
    p "response: #{notification.userInfo}"
    showPreferences
  end

  # from TrayMenu (via target action)
  def checkForUpdates(sender)
    updater.checkForUpdates(sender)
  end

  # from TrayMenu (via target action)
  def showAboutPanel(sender)
    NSApp.activateIgnoringOtherApps(true)
    NSApp.orderFrontStandardAboutPanel(sender)
  end

  # from TrayMenu (via target action)
  def quit(notification)
    puts 'Bye!'
    exit
  end

  # from TrayMenu (via target action)
  def showPreferences(sender)
    NSApp.activateIgnoringOtherApps(true)

    tokenTextField.stringValue = apiKey unless apiKey.nil?
    loginStartup.state = runAtLogin?

    preferencesWindow.makeKeyAndOrderFront(sender)
  end

  # from preferencesWindow (via delegate)
  def windowWillClose(notification)
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
    @statusBarItemController.menuIsActive = true
    @statusBarItemController.showImage
  end

  # from TrayMenu (via delegate)
  def menuDidClose(notification)
    @statusBarItemController.menuIsActive = false
    @statusBarItemController.showImage
  end

  def toggleRunAtStartup(sender)
    if sender.state == NSOnState
      NSApp.addToLoginItems
    else
      NSApp.removeFromLoginItems
    end
  end

  def runAtLogin?
    NSApp.isInLoginItems == 1
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
