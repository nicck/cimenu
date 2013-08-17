require 'lib/preferences'

class TrayMenu < NSMenu
  def initialize(delegate)
    self.delegate = delegate
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

  private

  def addBranchesFor(project)
    project['branches'].each do |branch|
      item = NSMenuItem.new

      branch_name = branch['branch_name']
      item.title = truncate(branch_name, 32)
      puts item.title.length
      item.target = delegate
      item.action = 'quit:'
      item.image = NSImage.alloc.initWithContentsOfFile "img/icon_offline@2x.png"

      addItem(item)
    end

    addItem(NSMenuItem.separatorItem)
  end

  def truncate(branch_name, length)
    if branch_name.length > length
      "#{branch_name[0..length / 2 - 1]}...#{branch_name[-length / 2..-1]}"
    else
     branch_name
    end
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
