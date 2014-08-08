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
            .statusItemWithLength( CGFloat(NSVariableStatusItemLength) )
        statusBar.highlightMode = true
    }
    
    func showImage() {
        statusBar.image = menuIsActive ? alternateImage : image
    }

}
