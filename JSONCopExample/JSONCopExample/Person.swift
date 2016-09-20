//
//  Person.swift
//  JSONCopExample
//
//  Created by Draveness on 9/20/16.
//  Copyright © 2016 Draveness. All rights reserved.
//

import Foundation

//@jsoncop
struct Person {
    let id: Int
    let name: String
    let projects: [Project]
    
    static func projectsJSONTransformer(value: [[String: Any]]) -> [Project] {
        return value.flatMap(Project.parse)
    }
}

//@jsoncop
struct Project {
    let name: String
}

// MARK: - JSONCop-Start

extension Person {
    static func parse(json: Any) -> Person? {
        guard let json = json as? [String: Any] else { return nil }
        guard let id = json["id"] as? Int,
			let name = json["name"] as? String,
			let projects = (json["projects"] as? [[String: Any]]).flatMap(projectsJSONTransformer) else { return nil }
        return Person(id: id, name: name, projects: projects)
    }
    static func parses(jsons: Any) -> [Person] {
        guard let jsons = jsons as? [[String: Any]] else { return [] }
        return jsons.flatMap(parse)
    }
}

extension Project {
    static func parse(json: Any) -> Project? {
        guard let json = json as? [String: Any] else { return nil }
        guard let name = json["name"] as? String else { return nil }
        return Project(name: name)
    }
    static func parses(jsons: Any) -> [Project] {
        guard let jsons = jsons as? [[String: Any]] else { return [] }
        return jsons.flatMap(parse)
    }
}

// MARK: - JSONCop-End