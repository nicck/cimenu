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
        fetchProjects()

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
        NSApplication.sharedApplication().terminate(self)
    }

// ----

    let responseData = NSMutableData()
    var statusCode:Int = -1

    func fetchProjects() {
        let url: NSURL = NSURL(string: "http://localhost/projects.json")
        println("fetchProjects() \(url)")
        let request = NSURLRequest(URL: url)

        NSURLConnection.connectionWithRequest(request, delegate:self)
    }

    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        let httpResponse = response as NSHTTPURLResponse
        statusCode = httpResponse.statusCode
        switch (httpResponse.statusCode) {
        case 201, 200, 401:
            responseData.length = 0
        default:
            println("ignore")
        }
    }

    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
//        println("self.responseData.appendData(data)")
        responseData.appendData(data)
    }

    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var error: NSError?

        var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(
            responseData,
            options: NSJSONReadingOptions.MutableLeaves,
            error: &error
        )

        if error != nil {
            println("callback(nil, error)")
            return
        }

        var projects = handleGetProjects(json)

        for project in projects {
            println("PROJECT: \(project.name)")
        }


    }

    func handleGetProjects(json: AnyObject) -> Array<Project> {
        var projects = Array<Project>()
        if let projectObjects = json as? JSONArray {
            for projectObject: AnyObject in projectObjects {
                if let projectJson = projectObject as? JSONDictionary {
                    if let project = Project.createFromJson(projectJson) {
                        projects.append(project)
                    }
                }
            }
        }
        return projects;
    }
}

