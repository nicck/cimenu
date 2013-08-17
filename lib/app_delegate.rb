require 'lib/download'

class AppDelegate
  AUTH_TOKEN = ENV['SEM_AUTH_TOKEN']

  def applicationDidFinishLaunching(notification)
    puts 'Hi!'

    @iconActive = NSImage.alloc.initWithContentsOfFile "img/icon_offline@2x.png"

    statusBar.menu = trayMenu

    fetchProjects
  end

  def quit(notification)
    puts 'Bye!'
    exit
  end

  def preferences(notification)
    preferencesWindow.orderFrontRegardless
  end

  def reDrawMenu(projects)
    projects.each do |project|
      item = NSMenuItem.new
      item.title = project['name']

      @trayMenu.addItem(item)

      addBranchesFor(project)
    end

    @trayMenu.addItem(NSMenuItem.separatorItem)

    @trayMenu.addItem(preferencesItem)
    @trayMenu.addItem(quitItem)
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
      window.releasedWhenClosed = false
      # window.delegate = self
      window
    end
  end

  def fetchProjects
    url = "https://semaphoreapp.com/api/v1/projects?auth_token=#{AUTH_TOKEN}"

    request = NSMutableURLRequest.requestWithURL(NSURL.URLWithString(url))

    NSURLConnection.connectionWithRequest(request, delegate:ConnectionDelegate.new)
  end

  def addBranchesFor(project)
    project['branches'].each do |branch|
      item = NSMenuItem.new
      item.title = branch['branch_name']
      item.target = self
      item.action = 'quit:'
      item.image = iconActive

      @trayMenu.addItem(item)
    end
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

  def trayMenu
    @trayMenu ||= begin
      menu = NSMenu.new
      menu.delegate = self
      menu
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
