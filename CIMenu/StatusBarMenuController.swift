//
//  StatusBarMenuController.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 09.06.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

import Cocoa

class StatusBarMenuController: NSObject, NSMenuDelegate {
    let mainMenu = NSMenu()

    let preferencesWindowController = PreferencesWindowController(windowNibName: "PreferencesWindow")

    var aboutItem : NSMenuItem {
        let item = NSMenuItem()
        item.title = "About CIMenu"
        item.target = self
        item.action = "showAboutPanel:"
        return item
    }

    var preferencesItem : NSMenuItem {
        let item = NSMenuItem()
        item.title = "Preferences…"
        item.target = self
        item.action = "showPreferences:"
        return item
    }

    var quitItem : NSMenuItem {
        let item = NSMenuItem()
        item.title = "Quit"
        item.target = self
        item.action = "terminateApplication:"
        return item
    }

    init() {
        super.init()
        mainMenu.delegate = self

        mainMenu.addItem(NSMenuItem.separatorItem())
        mainMenu.addItem(aboutItem)
        mainMenu.addItem(preferencesItem)

        mainMenu.addItem(NSMenuItem.separatorItem())
        mainMenu.addItem(quitItem)
    }

    func showAboutPanel(sender : NSMenuItem!) {
        NSApp.activateIgnoringOtherApps(true)
        NSApp.orderFrontStandardAboutPanel(sender)
    }

    func showPreferences(sender : NSMenuItem) {
        println("GeneralPreferencesView")

        // https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/WinPanel/Concepts/HowWindowIsDisplayed.html#//apple_ref/doc/uid/20000222-BCIBIJJD

//        preferencesWindowController.showWindow(self)
        preferencesWindowController.window.makeKeyAndOrderFront(self)
        
    }

    func terminateApplication(sender : NSMenuItem) {
        println("exit!")
        NSApp.terminate(self)
    }
}
