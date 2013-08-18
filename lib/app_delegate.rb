require 'lib/tray_menu'
require 'lib/preferences'
require 'lib/status_bar'
require 'lib/data_fetcher'

class AppDelegate
  attr_reader :trayMenu, :authToken

  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    @trayMenu = TrayMenu.new(self)
    @trayMenu.reDraw

    statusBar.trayMenu = @trayMenu

    dataFetcher = DataFetcher.new(statusBar)
    dataFetcher.fetch
    dataFetcher.startTimer

    defaults = NSUserDefaults.standardUserDefaults
    api_key = defaults.objectForKey('org.cimenu.apikey')

    fetchProjects(api_key)
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

  def fetchProjects(api_key)
    url = "https://semaphoreapp.com/api/v1/projects?auth_token=#{api_key}"

    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(url))

    NSURLConnection.connectionWithRequest(request,
      delegate:ConnectionDelegate.new(statusBar))
  end

  private

  def preferencesWindow
    @preferencesWindow ||= Preferences::Window.new
  end

  def statusBar
    @statusBar ||= StatusBar.new(self)
  end
end
