//
//  DataFetcher.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 28.08.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

class DataFetcher {
    let url = "https://semaphoreapp.com/api/v1/projects?auth_token="
//    let url = "http://localhost/projects.json?auth_token="
    let interval = NSTimeInterval(15)
    let defaults = NSUserDefaults.standardUserDefaults()
    let notificationCenter = NSNotificationCenter.defaultCenter()

    var timer: NSTimer!

    init() {
//        notificationCenter.addObserver(self,
//            selector: Selector("fetch"),
//            name: "org.cimenu.preferences.token.changed",
//            object: nil
//        )
    }

    // without @objc 'Unrecognized selector' exeptions raises
    @objc func fetch() {
        let token = defaults.objectForKey("org.cimenu.apikey") as String

        self.notificationCenter.postNotificationName(
            "org.cimenu.semaphore.connectionWillStartLoading",
            object: nil,
            userInfo: nil
        )
        println("GET \(url + token)")
        request(.GET, url + token)
            .responseString { (request, response, string, error) in
                let json = JSON.parse(string!)

                self.notificationCenter.postNotificationName(
                    "org.cimenu.semaphore.dataReceived",
                    object: nil,
                    userInfo: ["json" : json]
                )
            }

    }

    func startTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(interval,
            target: self,
            selector: Selector("fetch"),
            userInfo: nil,
            repeats: true
        )
    }

    func stopTimer() {
        timer?.invalidate
        timer = nil
    }

    deinit {
        stopTimer()
    }
}
