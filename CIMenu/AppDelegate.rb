class AppDelegate
  attr_accessor :updater

  def applicationWillFinishLaunching(notification)
    puts 'applicationWillFinishLaunching'

    @statusBarItemController = StatusBarItemController.new

    icon_off = NSImage.imageNamed 'gear_offline.png'
    icon_inv = NSImage.imageNamed 'gear_clicked.png'

    @statusBarItemController.image = icon_off
    @statusBarItemController.alternateImage = icon_inv

    @statusBarItemController.menuIsActive = false
    @statusBarItemController.showImage
  end

  def applicationDidFinishLaunching(notification)
    puts 'applicationDidFinishLaunching'

    statusBarMenuController = StatusBarMenuController.new
    statusBarMenuController.updater = self.updater
    statusBarMenuController.statusBarItemController = @statusBarItemController

    @statusBarItemController.statusBarItemMenu = statusBarMenuController.mainMenu

    dataFetcher = DataFetcher.new
    dataFetcher.fetch
    dataFetcher.startTimer
  end
end

class CmdVTextField < NSTextField
  def performKeyEquivalent(event)
    if (event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask
      if event.charactersIgnoringModifiers.isEqualToString("v")
        NSApp.sendAction("paste:", to:self.window.firstResponder, from:self)
      end
    end
    super
  end
end
