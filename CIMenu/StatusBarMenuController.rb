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

        # item.title = project['name']
        item.attributedTitle = attributedTitleForProject(project)

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
    preferencesWindowController.showWindow(self)
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

  def menu(menu, willHighlightItem:item)
    p item
    if item && item.view
      menuItemView = item.view
      branchDetailsViewController.showNearView menuItemView
    end

  end

  private

  def branchDetailsViewController
    @branchDetailsViewController ||= BranchDetailsViewController.alloc.init
  end

  def preferencesWindowController
    generalViewController = GeneralPreferencesViewController.alloc.init
    # advancedViewController = AdvancedPreferencesViewController.alloc.init

    PreferencesWindowController.alloc.initWithViewControllers(
      # [generalViewController, nil, advancedViewController],
      [generalViewController],
      title:'Preferences'
    )
  end

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
      item.image = imageForBranch(branch)

      item.view = MenuItemViewController.alloc.initWithBranch(branch).view

      @mainMenu.addItem(item)
    end
  end

  def imageForBranch(branch)
    state = branch['result']

    # cool old school :)
    case state
    when 'passed'
      NSImage.imageNamed NSImageNameStatusAvailable
    when 'failed'
      NSImage.imageNamed NSImageNameStatusUnavailable
    when 'pending'
      NSImage.imageNamed NSImageNameStatusPartiallyAvailable
    else
      NSImage.imageNamed NSImageNameStatusNone
    end

    case state
    when 'passed', 'failed', 'pending'
      NSImage.imageNamed "build_#{state}.png"
    else
      NSImage.imageNamed NSImageNameStatusNone
    end
  end

  def truncate(branch_name, length)
    if branch_name.length > length
      "#{branch_name[0..length / 2 - 1]}...#{branch_name[-length / 2..-1]}"
    else
      branch_name
    end
  end

  def attributedTitleForProject(project)
    projectName = project['name']

    branchCount = project['branches'].count
    branchPassedCount = project['branches'].count { |branch| branch['result'] == 'passed' }
    branchFailedCount = project['branches'].count { |branch| branch['result'] == 'failed' }
    branchPendingCount = project['branches'].count { |branch| branch['result'] == 'pending' }

    title = "%s\n%d branch%s: %d failed, %d passed" % [
      projectName, branchCount, (branchCount > 1 ? 'es' : ''), branchFailedCount, branchPassedCount
    ]
    title << ", %d pending" % branchPendingCount if branchPendingCount > 0

    attributedTitle = NSMutableAttributedString.alloc.initWithString(title)

    defaultOptions = { NSFontAttributeName => NSFont.fontWithName('Menlo', size: 10.0) }
    projectNameOptions = defaultOptions.merge({
      NSFontAttributeName => NSFont.fontWithName("Lucida Grande", size: 15.0)
    })
    branchFailedCountOptions = defaultOptions.merge NSForegroundColorAttributeName => NSColor.redColor
    branchPassedCountOptions = defaultOptions.merge({
      NSForegroundColorAttributeName => NSColor.colorWithSRGBRed(0, green:0.8, blue:0, alpha:1)
    })
    branchPendingCountOptions = defaultOptions.merge NSForegroundColorAttributeName => NSColor.brownColor

    attributedTitle.addAttributes projectNameOptions, range:title.rangeOfString(projectName)

    range_begin = title.rangeOfString("#{branchFailedCount} failed").location
    range = range_begin...(range_begin + branchFailedCount.to_s.size)
    attributedTitle.addAttributes branchFailedCountOptions, range:range

    range_begin = title.rangeOfString("#{branchPassedCount} passed").location
    range = range_begin...(range_begin + branchPassedCount.to_s.size)
    attributedTitle.addAttributes branchPassedCountOptions, range:range

    if branchPendingCount > 0
      range_begin = title.rangeOfString("#{branchPendingCount} pending").location
      range = range_begin...(range_begin + branchPassedCount.to_s.size)
      attributedTitle.addAttributes branchPendingCountOptions, range:range
    end

    attributedTitle
  end
end

class BuildMenuItem < NSMenuItem
  attr_accessor :url
end

class MenuItemViewController < NSViewController
  attr_accessor :imageView, :labelView

  def init
    initWithNibName('MenuItemView', bundle:nil)
  end

  def initWithBranch(branch)
    @branch = branch
    init
  end

  def loadView
    super

    title = truncate(@branch['branch_name'], 32)
    image = imageForBranch(@branch)

    imageView.image = image
    labelView.stringValue = title
  end

  private

  def imageForBranch(branch)
    state = branch['result']

    # cool old school :)
    case state
    when 'passed'
      NSImage.imageNamed NSImageNameStatusAvailable
    when 'failed'
      NSImage.imageNamed NSImageNameStatusUnavailable
    when 'pending'
      NSImage.imageNamed NSImageNameStatusPartiallyAvailable
    else
      NSImage.imageNamed NSImageNameStatusNone
    end

    case state
    when 'passed', 'failed', 'pending'
      NSImage.imageNamed "build_#{state}.png"
    else
      NSImage.imageNamed NSImageNameStatusNone
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

require "digest/md5"
class BranchDetailsViewController < NSViewController
  attr_accessor :textField, :imageView

  def init
    initWithNibName('BranchDetailsView', bundle:nil)
  end

  def showNearView(menuItemView)
    # view.setFrameSize([300, 100+rand(200)])
    # popover.contentSize = view.frame.size

    popover.showRelativeToRect menuItemView.bounds, # frame
      ofView:menuItemView,
      preferredEdge:NSMinXEdge

    email = 'nicck.olay@gmail.com'
    md5hex = Digest::MD5.hexdigest(email)
    # url = NSURL.URLWithString "https://identicons.github.com/nicck.png"
    url = NSURL.URLWithString "http://2.gravatar.com/avatar/#{md5hex}.png"
    image = NSImage.alloc.initWithContentsOfURL(url)

    imageView.image = image
  end

  # def viewDidLoad
  #   textField.stringValue = Time.now.to_s * (rand(3)+1)
  #   textField.sizeToFit
  # end

  def close
    popover.close
  end

  private

  def popover
    @popover ||= begin
      popover = NSPopover.alloc.init

      popover.behavior = NSPopoverBehaviorApplicationDefined # NSPopoverBehaviorSemitransient # NSPopoverBehaviorTransient
      popover.animates = true
      popover.contentViewController = self

      popover
    end
  end
end

