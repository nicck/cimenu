class PreferencesWindowController < NSWindowController
  attr_accessor :tokenTextField
  attr_accessor :loginStartup

  def init
    NSNotificationCenter.defaultCenter.addObserver(self,
      selector:"dataParseFailed:",
      name:"com.cimenu.CIMenu.semaphore.dataParseFailed",
      object:nil)

    initWithWindowNibName 'PreferencesWindow'
  end

  def showWindow(sender)
    super

    NSApp.activateIgnoringOtherApps(true)
    window.makeKeyAndOrderFront(self)
  end

  def windowDidLoad
    super
    p 'windowDidLoad'

    tokenTextField.stringValue = apiKey unless apiKey.nil?
    loginStartup.state = runAtLogin?
  end

  # from window (via delegate)
  def windowWillClose(notification)
    p 'windowWillClose'
  end

  # from tokenTextField (via delegate)
  def controlTextDidChange(notification)
    value = notification.object.stringValue

    if value.length == 20
      p "controlTextDidChange and length is 20: #{value}"
      self.apiKey = value
      # @dataFetcher.fetch
      NSNotificationCenter.defaultCenter.postNotificationName(
        "com.cimenu.CIMenu.preferences.token.changed",
        object:nil,
        userInfo:value)
    end
  end

  # from Check Box via Sent Actions
  def toggleRunAtStartup(sender)
    if sender.state == NSOnState
      NSApp.addToLoginItems
    else
      NSApp.removeFromLoginItems
    end
  end

  def dataParseFailed(notification)
    p "response: #{notification.userInfo}"
    self.showWindow(self)
  end

  private

  def runAtLogin?
    NSApp.isInLoginItems == 1
  end

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
