class PreferencesWindowController < MASPreferencesWindowController
  def showWindow(sender)
    super

    NSApp.activateIgnoringOtherApps(true)
    window.makeKeyAndOrderFront(self)
  end

  def windowDidLoad
    super
    p 'PreferencesWindow DidLoad'
  end

  def windowWillClose(notification)
    p 'PreferencesWindow WillClose'
  end
end
