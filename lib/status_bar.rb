class StatusBar
  attr_accessor :delegate

  def initialize(delegate)
    self.delegate = delegate

    @statusBar = NSStatusBar
      .systemStatusBar
      .statusItemWithLength(NSVariableStatusItemLength)

    @statusBar.image = iconActive
    @statusBar.highlightMode = true
  end

  def trayMenu=(menu)
    @statusBar.menu = menu
  end

  def trayMenu
    @statusBar.menu
  end

  def menuWillOpen
    @statusBar.image = iconClicked
  end

  def menuDidClose
    @statusBar.image = iconActive
  end

  def startAnimation
    @animationFrame = 0
    @animationTimer = NSTimer.scheduledTimerWithTimeInterval 0.02,
      target:self,
      selector:'updateImage:',
      userInfo:nil,
      repeats:true
  end

  def stopAnimation
    p 'stopAnimation'
    @animationTimer.invalidate && @animationTimer = nil if @animationTimer
    self.iconActive = @statusBar.image
  end

  def updateImage(timer)
    @statusBar.image = iconOfflineForFrame(@animationFrame)
    @animationFrame = (@animationFrame == 9) ? 1 : @animationFrame + 1
  end

  private

  def iconOffline
    @iconOffline ||= NSImage.alloc.initWithContentsOfFile "img/icon_offline@2x.png"
  end

  def iconOfflineForFrame(frame)
    NSImage.alloc.initWithContentsOfFile "img/animation/#{frame}.png"
  end

  def iconActive=(icon)
    @iconActive = icon
  end

  def iconActive
    @iconActive ||= iconOffline
  end

  def iconClicked
    @iconClicked ||= NSImage.alloc.initWithContentsOfFile "img/icon_clicked@2x.png"
  end
end
