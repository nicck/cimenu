//
//  Project.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 10.08.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

//typealias JSONDictionary = Dictionary<String, AnyObject>
//typealias JSONArray = Array<AnyObject>

class Project {
    let name: String
    let branches: [Branch]
    let recentBranches: [Branch]

    class func fromJson(projectsJson: [JSON]) -> [Project] {
        var projects: [Project] = []

        for projectJson in projectsJson {
            let project = Project(projectJson: projectJson)
            projects.append(project)
        }

        return projects
    }

    init(projectJson: JSON) {
        name = projectJson["name"].asString!

        let branchesJson = projectJson["branches"].asArray!
        branches = Branch.fromJson(branchesJson)

        let now = NSDate()
        let dayInSeconds = Double(86400)
        let interval: NSTimeInterval = now.timeIntervalSinceReferenceDate - dayInSeconds * Double(2)
        let twoWeeksAgo = NSDate(timeIntervalSinceReferenceDate: interval)

        recentBranches = branches.filter({ (branch: Branch) -> Bool in
            branch.startedAt.compare(twoWeeksAgo) == NSComparisonResult.OrderedDescending
        })
    }
}

//class ProjectJSON : JSON {
//    override init(_ obj:AnyObject){ super.init(obj) }
//    override init(_ json:JSON)  { super.init(json) }
//    var null  :NSNull? { return self["null"].asNull }
//    var bool  :Bool?   { return self["bool"].asBool }
//    var int   :Int?    { return self["int"].asInt }
//    var double:Double? { return self["double"].asDouble }
//    var string:String? { return self["string"].asString }
//    var url:   String? { return self["url"].asString }
//    var array :MyJSON  { return MyJSON(self["array"])  }
//    var object:MyJSON  { return MyJSON(self["object"]) }
//}