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

//    var projectsList :

    private var loadingItem: NSMenuItem {
        let item = NSMenuItem()
        item.title = "...loading..."
        return item
    }

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

    override init() {
        super.init()
        mainMenu.delegate = self

        mainMenu.addItem(loadingItem)

        let token = NSUserDefaults.standardUserDefaults().objectForKey("org.cimenu.apikey") as String
        request(.GET, "https://semaphoreapp.com/api/v1/projects?auth_token=" + token)
            .responseString { (request, response, string, error) in
                let json = JSON.parse(string!)
                let projects = Project.fromJson(json.asArray!)

                self.updateMenu(projects)
            }
    }

    func updateMenu(projects: [Project]) {
        mainMenu.removeAllItems()

        for project in projects {
            if countElements(project.recentBranches) > 0 {
                let item = NSMenuItem()
                item.title = project.name

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
}

class MyNSMenuItem: NSMenuItem {
    var url: String!
}