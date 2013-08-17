require 'lib/connection_delegate'
require 'lib/menu'
require 'lib/preferences'

class AppDelegate
  AUTH_TOKEN = ENV['SEM_AUTH_TOKEN']

  attr_reader :menu

  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    @iconActive = NSImage.alloc.initWithContentsOfFile "img/icon_offline@2x.png"

    @menu = Menu.new(self)
    statusBar.menu = @menu

    fetchProjects
  end

  def quit(notification)
    puts 'Bye!'
    exit
  end

  def showPreferences(notification)
    preferencesWindow.show
  end

  private

  def preferencesWindow
    @preferencesWindow ||= Preferences::Window.new
  end

  def fetchProjects
    url = "https://semaphoreapp.com/api/v1/projects?auth_token=#{AUTH_TOKEN}"

    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(url))

    NSURLConnection.connectionWithRequest(request, delegate:ConnectionDelegate.new)
  end

  def statusBar
    @statusBar ||= begin
      image = NSImage.alloc.initWithContentsOfFile "img/icon_offline@2x.png"

      statusBar = NSStatusBar
        .systemStatusBar
        .statusItemWithLength(NSVariableStatusItemLength)
      statusBar.image = image
      statusBar.highlightMode = true
      statusBar
    end
  end

  def iconActive
    @iconActive
  end

  def iconClicked
    @iconClicked ||= NSImage.alloc.initWithContentsOfFile "img/icon_clicked@2x.png"
  end

  def menuWillOpen(notification)
    statusBar.image = iconClicked
  end

  def menuDidClose(notification)
    statusBar.image = iconActive
  end
end
