//
//  StatusBarItemController.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 09.06.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

import Cocoa

class StatusBarItemController {
    let statusBar : NSStatusItem
    let image = NSImage(named:"gear_offline")
    let alternateImage = NSImage(named:"gear_clicked")

    let notificationCenter = NSNotificationCenter.defaultCenter()

    var menuIsActive = false
    var statusBarItemMenu : NSMenu {
        set(menu) {
            statusBar.menu = menu
        }
        get {
            return statusBar.menu
        }
    }
    
    init() {
        statusBar = NSStatusBar
            .systemStatusBar()
            .statusItemWithLength(-1) // linker error (bug) http://stackoverflow.com/a/24026327
//            .statusItemWithLength(NSVariableStatusItemLength)

        statusBar.highlightMode = true

        subscribeToConnectionEvents()
    }

    func showImage() {
        statusBar.image = menuIsActive ? alternateImage : image
    }

    @objc func startLoading() {
        println("startLoading")
    }

    @objc func stopLoading() {
        println("stopLoading")
    }

    private func subscribeToConnectionEvents() {
        notificationCenter.addObserver(self,
            selector: Selector("startLoading"),
            name: "org.cimenu.semaphore.connectionWillStartLoading",
            object: nil
        )

        notificationCenter.addObserver(self,
            selector: Selector("stopLoading"),
            name: "org.cimenu.semaphore.dataReceived",
            object: nil
        )

    }
}
