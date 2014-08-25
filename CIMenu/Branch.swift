//
//  Branch.swift
//  CIMenu
//
//  Created by Nickolay Abdrafikov on 17.08.14.
//  Copyright (c) 2014 Nickolay Abdrafikov. All rights reserved.
//

class Branch {
    let branchName: String
    let startedAt: NSDate
    let buildUrl: String
    let result: String

    var image: NSImage {
        switch result {
        case "passed":
            return NSImage(named: NSImageNameStatusAvailable)
        case "failed":
            return NSImage(named: NSImageNameStatusUnavailable)
        case "pending":
            return NSImage(named: NSImageNameStatusPartiallyAvailable)
        default:
            return NSImage(named: NSImageNameStatusNone)
        }
    }

    class func fromJson(branchesJson: [JSON]) -> [Branch] {
        var branches: [Branch] = []

        for branchJson in branchesJson {
            let branch = Branch(branchJson: branchJson)
            branches.append(branch)
        }

        return branches
    }

    init(branchJson: JSON) {
        startedAt = branchJson["started_at"].asDate!
        branchName = branchJson["branch_name"].asString!
        buildUrl = branchJson["build_url"].asString!
        result = branchJson["result"].asString!
    }
}
