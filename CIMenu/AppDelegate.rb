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

  attr_accessor :preferencesWindow
  attr_accessor :tokenTextField
  attr_accessor :loginStartup
  attr_accessor :updater

  def applicationDidFinishLaunching(notification)
    puts 'applicationDidFinishLaunching'

    statusBarMenuController = StatusBarMenuController.new
    statusBarMenuController.preferencesWindow = self.preferencesWindow
    statusBarMenuController.updater = self.updater
    statusBarMenuController.statusBarItemController = @statusBarItemController

    @statusBarItemController.statusBarItemMenu = statusBarMenuController.mainMenu

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

  # from preferencesWindow (via delegate)
  def windowWillClose(notification)
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
