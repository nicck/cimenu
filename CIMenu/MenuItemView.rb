class MenuItemView < NSView
  attr_accessor :labelView

  def awakeFromNib
    setupTrackingArea
  end

  def setupTrackingArea
    return if @trackingArea

    trackingOptions = NSTrackingEnabledDuringMouseDrag |
      NSTrackingMouseEnteredAndExited |
      NSTrackingActiveInActiveApp |
      NSTrackingActiveAlways

    @trackingArea = NSTrackingArea.alloc.initWithRect(frame,
      options:trackingOptions,
      owner:self,
      userInfo:nil)

    addTrackingArea @trackingArea
  end

  def drawRect(rect)
    if enclosingMenuItem.isHighlighted
      # NSColor.colorWithDeviceWhite(0.95, alpha:1.0).set
      NSColor.selectedMenuItemColor.set
      NSBezierPath.fillRect(rect)
    else
      super #(rect)
    end
  end

  def mouseUp(theEvent)
    item = enclosingMenuItem

    menu = item.menu
    menu.cancelTracking

    index = menu.indexOfItem(item)

    # hack to reset highlighted menu item state
    menu.removeItemAtIndex(index)
    menu.insertItem(item, atIndex:index)

    menu.performActionForItemAtIndex(index)
  end

  def mouseEntered(theEvent)
    labelView.textColor = NSColor.whiteColor
  end

  def mouseExited(theEvent)
    labelView.textColor = NSColor.blackColor
  end

end
