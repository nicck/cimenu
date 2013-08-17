framework 'AppKit'

require 'lib/app_delegate'

app = NSApplication.sharedApplication
app.delegate = AppDelegate.new

app.run
