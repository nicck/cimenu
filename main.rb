framework 'AppKit'

class AppDelegate
  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    statusBar.menu = trayMenu
    trayMenu.addItem(quitItem)
  end

  def quit(notification)
    puts 'Bye!'
    exit
  end

  private

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
end


app = NSApplication.sharedApplication
app.delegate = AppDelegate.new

app.run
