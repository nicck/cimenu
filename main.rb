require 'lib/app_delegate'

framework 'AppKit'

app = NSApplication.sharedApplication
app.delegate = AppDelegate.new

app.run
