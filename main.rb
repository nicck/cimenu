framework 'AppKit'

class AppDelegate
  def applicationDidFinishLaunching(notification)
    statusBar = NSStatusBar
        .systemStatusBar
        .statusItemWithLength(NSVariableStatusItemLength)

    item = NSMenuItem.new
    item.title = 'Quit'
    item.target = self
    item.action = 'quit:'

    menu = NSMenu.new
    menu.addItem(item)

    statusBar.menu = menu
    statusBar.title = "CI Menu"
    statusBar.highlightMode = true

    puts 'started'
  end

  def quit(notification)
    puts "Bye!"
    exit
  end
end


app = NSApplication.sharedApplication
app.delegate = AppDelegate.new

app.run
