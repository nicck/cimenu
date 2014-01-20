class StatusBarItemController
  attr_accessor :image, :alternateImage, :menuIsActive

  def initialize
    @statusBar = NSStatusBar
      .systemStatusBar
      .statusItemWithLength(NSVariableStatusItemLength)
    @statusBar.highlightMode = true

    subscribeToConnectionEvents
  end

  def statusBarItemMenu=(menu)
    @statusBar.menu = menu
  end

  def connectionWillStartLoading(notification)
    startAnimation
  end

  def connectionDidFinishLoading(notification)
    stopAnimation
  end

  def showImage
    @statusBar.image = @menuIsActive ? alternateImage : image
  end

  # from timer
  def updateImage(timer)
    @statusBar.image = imageForFrame(@animationFrame)
    @animationFrame = (@animationFrame == 9) ? 1 : @animationFrame + 1
  end

  private

  def subscribeToConnectionEvents
    NSNotificationCenter.defaultCenter.addObserver self,
       selector:"connectionWillStartLoading:",
       name:"com.cimenu.CIMenu.semaphore.connectionWillStartLoading",
       object:nil

    NSNotificationCenter.defaultCenter.addObserver self,
       selector:"connectionDidFinishLoading:",
       name:"com.cimenu.CIMenu.semaphore.connectionDidFinishLoading",
       object:nil
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
    if @animationTimer
      @animationTimer.invalidate && @animationTimer = nil
    end
  end

  def imageForFrame(frame)
    NSImage.imageNamed "#{frame}.png"
  end
end
