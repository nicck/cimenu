require 'lib/connection_delegate'
require 'lib/tray_menu'
require 'lib/preferences'
require 'lib/status_bar'

class AppDelegate
  AUTH_TOKEN = ENV['SEM_AUTH_TOKEN']

  attr_reader :trayMenu

  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    @trayMenu = TrayMenu.new(self)
    statusBar.menu = @trayMenu

    fetchProjects
  end

  def quit(notification)
    puts 'Bye!'
    exit
  end

  def showPreferences(notification)
    preferencesWindow.show
  end

  def menuWillOpen(notification)
    statusBar.menuWillOpen
  end

  def menuDidClose(notification)
    statusBar.menuDidClose
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
    @statusBar ||= StatusBar.new(self)
  end
end
