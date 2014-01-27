class AdvancedPreferencesViewController < NSViewController # MASPreferencesViewController
  def init
    initWithNibName('AdvancedPreferencesView', bundle:nil)
  end

  def identifier
    'AdvancedPreferences'
  end

  def toolbarItemImage
    NSImage.imageNamed NSImageNameAdvanced
  end

  def toolbarItemLabel
    'Advanced'
  end
end
