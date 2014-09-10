import Cocoa

class PreferencesWindowController: NSWindowController, NSTextFieldDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet private var tokenTextField : NSTextField!
    @IBOutlet private var startCheckBox : NSButton!
    
//    func windowWillLoad()
    override func windowDidLoad() {
        if let apiKey: AnyObject! = defaults.objectForKey("org.cimenu.apikey") {
            tokenTextField.stringValue = apiKey as NSString
        }

        if NSApp.isInLoginItems() {
            startCheckBox.state = NSOnState
        } else {
            startCheckBox.state = NSOffState
        }
    }
    

    override func controlTextDidChange(notification : NSNotification!) {
        let value = notification.object!.stringValue

        if (value as NSString).length == 20 {
            println("controlTextDidChange and length is 20: \(value)")
            defaults.setObject(value, forKey: "org.cimenu.apikey")
            defaults.synchronize()
        }
//
//        NSNotificationCenter.defaultCenter.postNotificationName(
//          'com.cimenu.CIMenu.preferences.token.changed',
//          object:nil,
//          userInfo:value)

    }

    @IBAction func toggleRunAtStartup(sender : NSButton) {
        if sender.state == NSOnState {
            println("NSApp.addToLoginItems")
            NSApp.addToLoginItems()
        } else {
            println("NSApp.removeFromLoginItems")
            NSApp.removeFromLoginItems()
        }
    }

}
