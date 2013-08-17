require 'lib/preferences'

class Menu < NSMenu
  def initialize(delegate)
    @delegate = delegate
  end

  def reDraw(projects)
    removeAllItems

    projects.each do |project|
      item = NSMenuItem.new
      item.title = project['name']

      addItem(item)

      addBranchesFor(project)
    end

    addItem(preferencesItem)
    addItem(quitItem)
  end

  def addBranchesFor(project)
    project['branches'].each do |branch|
      item = NSMenuItem.new
      item.title = branch['branch_name']
      item.target = delegate
      item.action = 'quit:'
      item.image = NSImage.alloc.initWithContentsOfFile "img/icon_offline@2x.png"

      addItem(item)
    end

    addItem(NSMenuItem.separatorItem)
  end

  def quitItem
    @quitItem ||= begin
      item = NSMenuItem.new
      item.title = 'Quit'
      item.target = delegate
      item.action = 'quit:'
      item
    end
  end

  def preferencesItem
    @preferencesItem ||= Preferences::MenuItem.new(delegate)
  end
end
