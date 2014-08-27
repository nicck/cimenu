//
//  AppDelegate.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 09.06.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    let dataFetcher = DataFetcher()
    let statusBarItemController = StatusBarItemController()
    var statusBarMenuController: StatusBarMenuController!

    func applicationWillFinishLaunching(aNotification: NSNotification?) {
        println("applicationWillFinishLaunching")
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        println("applicationDidFinishLaunching")
        statusBarMenuController = StatusBarMenuController()
        statusBarItemController.statusBarItemMenu = statusBarMenuController.mainMenu
        statusBarItemController.showImage()
//        statusBarMenuController.updater = self.updater
//        statusBarMenuController.statusBarItemController = statusBarItemController

        dataFetcher.fetch()
        dataFetcher.startTimer()
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        println("applicationWillTerminate")
    }
}

