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
    let branches: [Branch]

    init(name: String, branches: [Branch]) {
        self.name = name
        self.branches = branches
    }
}

class ProjectJSON : JSON {
    override init(_ obj:AnyObject){ super.init(obj) }
    override init(_ json:JSON)  { super.init(json) }
    var name: String? { return self["name"].asString }
//    var null  :NSNull? { return self["null"].asNull }
//    var bool  :Bool?   { return self["bool"].asBool }
//    var int   :Int?    { return self["int"].asInt }
//    var double:Double? { return self["double"].asDouble }
//    var string:String? { return self["string"].asString }
//    var url:   String? { return self["url"].asString }
//    var array :MyJSON  { return MyJSON(self["array"])  }
//    var object:MyJSON  { return MyJSON(self["object"]) }
}