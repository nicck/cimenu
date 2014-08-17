//
//  _connection_delegte.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 18.08.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

//        let url: NSURL = NSURL(string: "http://localhost/projects.json")
//        println("fetchProjects() \(url)")
//        let request = NSURLRequest(URL: url)
//
//        NSURLConnection.connectionWithRequest(request, delegate: ConnectionDelegate())

class ConnectionDelegate {
    let responseData = NSMutableData()
    var statusCode:Int = -1

    func connection(NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
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

    func connectionDidFinishLoading(NSURLConnection!) {
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

        //        var projects = handleGetProjects(json)
    }

//    func handleGetProjects(json: AnyObject) -> Array<Project> {
//        //        var projects = Array<Project>()
//        var projects : [Project] = []
//        if let projectObjects = json as? JSONArray {
//            for projectObject: AnyObject in projectObjects {
//                if let projectJson = projectObject as? JSONDictionary {
//                    let project = Project.createFromJson(projectJson)
//                    projects.append(project)
//                }
//            }
//        }
//        return projects;
//    }
}