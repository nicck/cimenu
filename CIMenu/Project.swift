//
//  Project.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 10.08.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

typealias JSONDictionary = Dictionary<String, AnyObject>
typealias JSONArray = Array<AnyObject>

class Project {
    let name: String
    //    let owner: String

    class func createFromJson(json: JSONDictionary) -> Project? {
        //        println("JSON: \(json)")
        if let projectName: AnyObject = json["name"] {
            return Project(name: projectName as String)
        } else {
            return Project(name: "--no-name--")
        }
    }

    init(name: String) {
        self.name = name
        //        owner = "ow"
    }
}