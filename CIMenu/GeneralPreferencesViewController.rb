class GeneralPreferencesViewController < NSViewController # MASPreferencesViewController
  attr_accessor :tokenTextField
  attr_accessor :loginStartup

  def init
    initWithNibName('GeneralPreferencesView', bundle:nil)
  end

  def identifier
    'GeneralPreferences'
  end

  def toolbarItemImage
    NSImage.imageNamed NSImageNamePreferencesGeneral
  end

  def toolbarItemLabel
    'General'
  end

  def viewDidLoad
    tokenTextField.stringValue = apiKey unless apiKey.nil?
    loginStartup.state = runAtLogin?
  end

  # from Check Box via Sent Actions
  def toggleRunAtStartup(sender)
    if sender.state == NSOnState
      NSApp.addToLoginItems
    else
      NSApp.removeFromLoginItems
    end
  end

  # from tokenTextField (via delegate)
  def controlTextDidChange(notification)
    value = notification.object.stringValue

    if value.length == 20
      p "controlTextDidChange and length is 20: #{value}"
      self.apiKey = value

      NSNotificationCenter.defaultCenter.postNotificationName(
        'com.cimenu.CIMenu.preferences.token.changed',
        object:nil,
        userInfo:value)
    end
  end

  def loadView
    super
    viewDidLoad
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
