framework 'AppKit'

class AppDelegate
  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    trayMenu.addItem(preferencesItem)
    trayMenu.addItem(quitItem)

    statusBar.menu = trayMenu
  end

  def quit(notification)
    puts 'Bye!'
    exit
  end

  def preferences(notification)
    preferencesWindow.display
  end

  private

  def preferencesWindow
    @preferencesWindow ||= begin
      window = NSWindow.alloc.initWithContentRect [200, 300, 300, 100],
        styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask,
        backing:NSBackingStoreBuffered,
        defer:false
      window.title = 'Preferences'
      window.level = NSModalPanelWindowLevel
      # window.delegate = app.delegate
      window.orderFrontRegardless
    end
  end

  def statusBar
    @statusBar ||= begin
      statusBar = NSStatusBar
        .systemStatusBar
        .statusItemWithLength(NSVariableStatusItemLength)
      statusBar.title = "CI Menu"
      statusBar.highlightMode = true
      statusBar
    end
  end

  def trayMenu
    @trayMenu ||= begin
      menu = NSMenu.new
      menu
    end
  end

  def quitItem
    @quitItem ||= begin
      item = NSMenuItem.new
      item.title = 'Quit'
      item.target = self
      item.action = 'quit:'
      item
    end
  end

  def preferencesItem
    @preferencesItem ||= begin
      item = NSMenuItem.new
      item.title = 'Preferences'
      item.target = self
      item.action = 'preferences:'
      item
    end
  end
end


app = NSApplication.sharedApplication
app.delegate = AppDelegate.new

app.run
