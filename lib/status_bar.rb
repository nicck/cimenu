class StatusBar
  attr_accessor :delegate

  def initialize(delegate)
    self.delegate = delegate

    @iconOffline = NSImage.alloc.initWithContentsOfFile "img/icon_offline@2x.png"
    @iconActive = NSImage.alloc.initWithContentsOfFile "img/icon_offline@2x.png"

    @statusBar = NSStatusBar
      .systemStatusBar
      .statusItemWithLength(NSVariableStatusItemLength)

    @statusBar.image = @iconOffline
    @statusBar.highlightMode = true
  end

  def menu=(menu)
    @statusBar.menu = menu
  end

  def menuWillOpen
    @statusBar.image = iconClicked
  end

  def menuDidClose
    @statusBar.image = iconActive
  end

  private

  def iconActive
    @iconActive
  end

  def iconClicked
    @iconClicked ||= NSImage.alloc.initWithContentsOfFile "img/icon_clicked@2x.png"
  end
end
