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
        updateMenu()
    }

    func updateMenu() {
        mainMenu.removeAllItems()

//        "http://localhost/projects.json"
//        println(projectsList)
        let json = JSON.fromURL("http://localhost/projects.json")

        var projects: [Project] = []

        if let projectsJson = json.asArray {
            for projectJson in projectsJson {
//                println(projectJson)
//                println("---------")

                if let name = projectJson["name"].asString {
                    var branches: [Branch] = []

                    if let branchesJson = projectJson["branches"].asArray {
                        for branchJson in branchesJson {

                            if let name = branchJson["branch_name"].asString {
                                let branch = Branch(branchName: name)
                                branches.append(branch)
                            } else {
                                let e = branchJson["branch_name"].asError
                                println(e)
                            }

                        }
                    }
                    let project = Project(name: name, branches: branches)
                    projects.append(project)
                }
            }
        }

        for project in projects {
            let item = NSMenuItem()
            item.title = project.name
            mainMenu.addItem(item)
            for branch in project.branches {
                let item = NSMenuItem()
                item.title = "-- " + branch.branchName
                mainMenu.addItem(item)
            }
        }

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

// TO READ: https://developer.apple.com/library/mac/documentation/cocoa/Conceptual/WinPanel/Concepts/HowWindowIsDisplayed.html#//apple_ref/doc/uid/20000222-BCIBIJJD
    func showPreferences(NSMenuItem) {
        println("GeneralPreferencesView")
//        preferencesWindowController.showWindow(self)
        preferencesWindowController.window.makeKeyAndOrderFront(self)
    }

    func terminateApplication(sender : NSMenuItem) {
        println("exit!")
        NSApplication.sharedApplication().terminate(self)
    }

}

