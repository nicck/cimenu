class StatusBar
  attr_accessor :delegate

  def initialize(delegate, menu)
    self.delegate = delegate

    @statusBar = NSStatusBar
      .systemStatusBar
      .statusItemWithLength(NSVariableStatusItemLength)

    @statusBar.menu = menu
    @statusBar.image = iconActive
    @statusBar.highlightMode = true

    NSNotificationCenter.defaultCenter.addObserver(self,
       selector:"dataFetching:",
       name:"com.cimenu.CIMenu.data.fetching",
       object:nil)

    NSNotificationCenter.defaultCenter.addObserver(self,
       selector:"dataDone:",
       name:"com.cimenu.CIMenu.data.done",
       object:nil)
  end

  def menuWillOpen
    @statusBar.image = iconClicked
  end

  def menuDidClose
    @statusBar.image = iconActive
  end

  def startAnimation
    unless @animationTimer
      @animationFrame = 0
      @animationTimer = NSTimer.scheduledTimerWithTimeInterval 0.02,
        target:self,
        selector:'updateImage:',
        userInfo:nil,
        repeats:true

      NSRunLoop.mainRunLoop.addTimer(@animationTimer, forMode:NSRunLoopCommonModes)
    end
  end

  def stopAnimation
    p 'stopAnimation'
    @animationTimer.invalidate && @animationTimer = nil if @animationTimer
    self.iconActive = @statusBar.image
  end

  def updateImage(timer)
    @statusBar.image = iconActiveForFrame(@animationFrame)
    @animationFrame = (@animationFrame == 9) ? 1 : @animationFrame + 1
  end

  def updateIconWithData(projects)
    pending = projects.any? do |project|
      branches = project['branches'] || []
      branches.any? do |branch|
        ('master' == branch['branch_name']) &&
        ('pending' == branch['result'])
      end
    end

    pending ? startAnimation : stopAnimation
  end

  def dataFetching(notification)
    startAnimation
  end

  def dataDone(notification)
    stopAnimation
  end

  private

  def iconOffline
    @iconOffline ||= NSImage.imageNamed "gear_offline.png"
  end

  def iconActiveForFrame(frame)
    NSImage.imageNamed "#{frame}.png"
  end

  def iconActive=(icon)
    @iconActive = icon
  end

  def iconActive
    @iconActive ||= iconOffline
  end

  def iconClicked
    @iconClicked ||= NSImage.imageNamed "gear_clicked.png"
  end
end
