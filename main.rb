require 'json'

framework 'AppKit'

class AppDelegate
  AUTH_TOKEN = ENV['SEM_AUTH_TOKEN']

  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    statusBar.menu = trayMenu

    projects.each do |project|
      item = NSMenuItem.new
      item.title = project
      item.target = self
      item.action = 'quit:'

      trayMenu.addItem(item)
    end

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

  def projects
    url = "https://semaphoreapp.com/api/v1/projects?auth_token=#{AUTH_TOKEN}"

    url_object = NSURL.URLWithString(url)
    request = NSMutableURLRequest.requestWithURL(url_object,
      cachePolicy: NSURLRequestReloadIgnoringCacheData,
      timeoutInterval: 30.0)

    content = NSMutableString.alloc.initWithContentsOfURL(url_object,
      encoding:NSUTF8StringEncoding, error:nil)

    JSON.parse(content).map { |project| project['name'] }
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
