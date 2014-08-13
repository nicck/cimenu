//
//  AppDelegate.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 09.06.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let statusBarItemController = StatusBarItemController()
    let statusBarMenuController = StatusBarMenuController()

    func applicationWillFinishLaunching(aNotification: NSNotification?) {
        println("applicationWillFinishLaunching")
        statusBarItemController.statusBarItemMenu = statusBarMenuController.mainMenu
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        println("applicationDidFinishLaunching")
        statusBarItemController.showImage()
//        statusBarMenuController.updater = self.updater
//        statusBarMenuController.statusBarItemController = statusBarItemController
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        println("applicationWillTerminate")
    }
}

