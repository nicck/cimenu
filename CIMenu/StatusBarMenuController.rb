require 'time'

class StatusBarMenuController
  attr_reader :mainMenu

  attr_accessor :preferencesWindow, :updater
  attr_accessor :statusBarItemController

  def initialize
    setupMenu
    subscribeToConnectionEvents
  end

  def setupMenu
    @mainMenu = NSMenu.new
    @mainMenu.delegate = self
    updateMenu
  end

  def showAboutPanel(sender)
    NSApp.activateIgnoringOtherApps(true)
    NSApp.orderFrontStandardAboutPanel(sender)
  end

  def terminateApplication(sender)
    puts 'Bye!'
    NSApp.terminate self
    # exit
  end

  def dataReceived(notification)
    # TODO: try https://github.com/Simbul/semaphoreapp
    projectHash = notification.userInfo
    updateMenu(projectHash)
  end

  def updateMenu(projects = [])
    @mainMenu.removeAllItems

    projects.each do |project|
      branches = branchesFor(project)

      if branches.size > 0
        item = NSMenuItem.new
        item.title = project['name']

        @mainMenu.addItem(item)

        addBranches(branches)

        @mainMenu.addItem(NSMenuItem.separatorItem)
      end
    end

    @mainMenu.addItem(aboutItem)
    @mainMenu.addItem(updateItem)
    @mainMenu.addItem(preferencesItem)
    @mainMenu.addItem(NSMenuItem.separatorItem)
    @mainMenu.addItem(quitItem)
  end

  def openBuild(sender)
    url = NSURL.URLWithString(sender.url)
    NSWorkspace.sharedWorkspace.openURL(url)
  end

  def showPreferences(sender)
    NSApp.activateIgnoringOtherApps(true)

    # tokenTextField.stringValue = apiKey unless apiKey.nil?
    # loginStartup.state = runAtLogin?

    preferencesWindow.makeKeyAndOrderFront(sender)
  end

  def checkForUpdates(sender)
    updater.checkForUpdates(sender)
  end

  def menuWillOpen(notification)
    statusBarItemController.menuIsActive = true
    statusBarItemController.showImage
  end

  def menuDidClose(notification)
    statusBarItemController.menuIsActive = false
    statusBarItemController.showImage
  end

  private

  def subscribeToConnectionEvents
    NSNotificationCenter.defaultCenter.addObserver(self,
      selector:"dataReceived:",
      name:"com.cimenu.CIMenu.semaphore.dataReceived",
      object:nil
    )
  end

  def aboutItem
    @aboutItem ||= begin
      item = NSMenuItem.new
      item.title = 'About CIMenu'
      item.target = self
      item.action = 'showAboutPanel:'
      item
    end
  end

  def updateItem
    @updateItem ||= begin
      item = NSMenuItem.new
      item.title = 'Check for Updates…'
      item.target = self
      item.action = 'checkForUpdates:'
      item
    end
  end

  def preferencesItem
    @preferencesItem ||= begin
      item = NSMenuItem.new
      item.title = "Preferences…"
      item.target = self
      item.action = "showPreferences:"
      item
    end
  end

  def quitItem
    @quitItem ||= begin
      item = NSMenuItem.new
      item.title = 'Quit'
      item.target = self
      item.action = 'terminateApplication:'
      item
    end
  end

  def branchesFor(project)
    project['branches'].select do |branch|
      branch['finished_at'].nil? || Time.parse(branch['finished_at']) > 2.days.ago
    end
  end

  def addBranches(branches)
    branches.each do |branch|
      item = BuildMenuItem.new

      item.url = branch['build_url']
      item.title = truncate(branch['branch_name'], 32)
      item.target = self
      item.action = 'openBuild:'
      item.image = NSImage.imageNamed "build_#{branch['result']}.png"

      @mainMenu.addItem(item)
    end
  end

  def truncate(branch_name, length)
    if branch_name.length > length
      "#{branch_name[0..length / 2 - 1]}...#{branch_name[-length / 2..-1]}"
    else
      branch_name
    end
  end

end

class BuildMenuItem < NSMenuItem
  attr_accessor :url
end
