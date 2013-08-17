require 'lib/tray_menu'
require 'lib/preferences'
require 'lib/status_bar'
require 'lib/data_fetcher'

class AppDelegate
  attr_reader :trayMenu

  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    @trayMenu = TrayMenu.new(self)
    statusBar.menu = @trayMenu

    dataFetcher = DataFetcher.new(statusBar)
    dataFetcher.start
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

  def statusBar
    @statusBar ||= StatusBar.new(self)
  end
end
