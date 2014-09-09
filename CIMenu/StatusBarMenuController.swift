//
//  StatusBarMenuController.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 09.06.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

import Cocoa

class StatusBarMenuController: NSObject, NSMenuDelegate, NSURLConnectionDataDelegate {
    let mainMenu = NSMenu()
    let preferencesWindowController = PreferencesWindowController(windowNibName: "PreferencesWindow")
    let notificationCenter = NSNotificationCenter.defaultCenter()

    override init() {
        super.init()
        mainMenu.delegate = self

        mainMenu.addItem(loadingItem)

        notificationCenter.addObserver(self,
            selector: Selector("dataReceived:"),
            name: "org.cimenu.semaphore.dataReceived",
            object: nil
        )
    }

    func dataReceived(notification: NSNotification) {
        var json = notification.userInfo!["json"] as JSON
        let projects = Project.fromJson(json.asArray!)
        updateMenu(projects)
    }

    func updateMenu(projects: [Project]) {
        mainMenu.removeAllItems()

        mainMenu.addItem(headItem)

        for project in projects {
            if countElements(project.recentBranches) > 0 {
                let item = NSMenuItem()
                item.title = project.name

                mainMenu.addItem(NSMenuItem.separatorItem())
                mainMenu.addItem(item)
            }

            for branch in project.recentBranches {
                let item = MyNSMenuItem()

                item.title = branch.branchName
                item.image = branch.image
                item.url = branch.buildUrl
                item.target = self
                item.action = Selector("openBuild:")

                mainMenu.addItem(item)
            }
        }

        mainMenu.addItem(NSMenuItem.separatorItem())
        mainMenu.addItem(aboutItem)
        mainMenu.addItem(preferencesItem)
        
        mainMenu.addItem(NSMenuItem.separatorItem())
        mainMenu.addItem(quitItem)
    }
    
    func showAboutPanel(sender: NSMenuItem) {
        NSApp.activateIgnoringOtherApps(true)
        NSApp.orderFrontStandardAboutPanel(sender)
    }

// TO READ: https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/WinPanel/Concepts/HowWindowIsDisplayed.html#//apple_ref/doc/uid/20000222-BCIBIJJD
    func showPreferences(NSMenuItem) {
        println("GeneralPreferencesView")
//        preferencesWindowController.showWindow(self)
        preferencesWindowController.window.makeKeyAndOrderFront(self)
    }

    func terminateApplication(sender: NSMenuItem) {
        println("exit!")
        NSApplication.sharedApplication().terminate(self)
    }

    func openBuild(sender: MyNSMenuItem) {
        let url = NSURL.URLWithString(sender.url)
        NSWorkspace.sharedWorkspace().openURL(url)
    }

    private var headItem: NSMenuItem {
        var str = "<font face='Lucida Grande'><b>CI Menu</b> v1.0</font>"

            var attributedString = NSMutableAttributedString(
                HTML: str.dataUsingEncoding(NSUTF8StringEncoding),
                documentAttributes: nil)

            var paragraph = NSMutableParagraphStyle()

            paragraph.alignment = NSTextAlignment.LeftTextAlignment
            paragraph.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle

            attributedString.addAttribute(
                NSParagraphStyleAttributeName,
                value: paragraph,
                range: NSMakeRange(0, attributedString.length)
            )

            let item = NSMenuItem()
            item.attributedTitle = attributedString

            return item
    }

    private var loadingItem: NSMenuItem {
        let item = NSMenuItem()
            item.title = "Loading..."
            return item
    }

    private var aboutItem : NSMenuItem {
        let item = NSMenuItem()
            item.title = "About CIMenu"
            item.target = self
            item.action = "showAboutPanel:"
            return item
    }

    private var preferencesItem : NSMenuItem {
        let item = NSMenuItem()
            item.title = "Preferences…"
            item.target = self
            item.action = "showPreferences:"
            return item
    }

    private var quitItem : NSMenuItem {
        let item = NSMenuItem()
            item.title = "Quit"
            item.target = self
            item.action = "terminateApplication:"
            return item
    }

}

class MyNSMenuItem: NSMenuItem {
    var url: String!
}