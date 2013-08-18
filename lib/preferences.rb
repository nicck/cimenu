module Preferences
  class MenuItem < NSMenuItem
    def initialize(delegate)
      self.title = 'Preferences...'
      self.target = delegate
      self.action = 'showPreferences:'
    end
  end

  class ApiTextField < NSTextField
    def textDidChange(notification)
      save_api_key(stringValue)
    end

    def save_api_key(api_key)
      defaults = NSUserDefaults.standardUserDefaults
      defaults.setObject(api_key, forKey: 'org.cimenu.apikey')

      defaults.synchronize

      NSApplication.sharedApplication.delegate.fetchProjects(api_key)
    end
  end

  class Window
    def initialize
      frame = [200, 300, 550, 100]
      @window = NSWindow.alloc.initWithContentRect frame,
          styleMask:NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask,
          backing:NSBackingStoreBuffered,
          defer:false
      @window.title = 'Preferences'
      @window.level = NSModalPanelWindowLevel
      @window.releasedWhenClosed = false
      @window.delegate = self

      content_view = NSView.alloc.initWithFrame(frame)
      @window.contentView = content_view

      apiKeyLabel = NSTextField.alloc.initWithFrame([30, 40, 110, 20])
      apiKeyLabel.editable = false
      apiKeyLabel.selectable = false
      apiKeyLabel.bezeled = false
      apiKeyLabel.drawsBackground = false
      apiKeyLabel.stringValue = 'Api Token:'

      descriptionLabel = NSTextField.alloc.initWithFrame([230, 25, 500, 40])
      descriptionLabel.editable = false
      descriptionLabel.selectable = false
      descriptionLabel.bezeled = false
      descriptionLabel.drawsBackground = false
      descriptionLabel.font = NSFont.fontWithName('Arial', size:10.0)
      descriptionLabel.stringValue = "To use the Semaphore API, you need an auth_token. \nYou can find your token through the Semaphore web interface."

      @window.contentView.addSubview(apiKeyLabel)
      @window.contentView.addSubview(descriptionLabel)

      apiKeyTextField = ApiTextField.alloc.initWithFrame([100, 40, 120, 20])
      @window.contentView.addSubview(apiKeyTextField)
    end

    def show
      @window.makeKeyAndOrderFront(nil)
    end
  end
end
