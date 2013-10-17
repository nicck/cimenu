require 'time'

class TrayMenu < NSMenu
  def initialize(delegate)
    self.delegate = delegate
  end

  def reDraw(projects = [])
    removeAllItems

    projects.each do |project|
      branches = branchesFor(project)

      if branches.size > 0
        item = NSMenuItem.new
        item.title = project['name']
        addItem(item)

        addBranches(branches)

        addItem(NSMenuItem.separatorItem)
      end
    end

    addItem(preferencesItem)
    addItem(quitItem)
  end

  private

  def branchesFor(project)
    project['branches'].select do |branch|
      branch['finished_at'].nil? || Time.parse(branch['finished_at']) > 2.days.ago
    end
  end

  def addBranches(branches)
    branches.each do |branch|
      item = NSMenuItem.new

      item.title = truncate(branch['branch_name'], 32)
      item.target = delegate
      item.action = 'quit:'
      item.image = NSImage.imageNamed "build_#{branch['result']}.png"

      addItem(item)
    end
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
    @preferencesItem ||= begin
      item = NSMenuItem.new
      item.title = "Preferences…"
      item.target = delegate
      item.action = "showPreferences:"
      item
    end
  end
end
