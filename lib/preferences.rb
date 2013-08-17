module Preferences
  class MenuItem < NSMenuItem
    def initialize(delegate)
      self.title = 'Preferences...'
      self.target = delegate
      self.action = 'showPreferences:'
    end
  end

  class Window
    def initialize
      @window = NSWindow.alloc.initWithContentRect [200, 300, 300, 100],
          styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask,
          backing:NSBackingStoreBuffered,
          defer:false
      @window.title = 'Preferences'
      @window.level = NSModalPanelWindowLevel
      @window.releasedWhenClosed = false
      # @window.delegate = self
    end

    def show
      @window.orderFrontRegardless
    end
  end
end
