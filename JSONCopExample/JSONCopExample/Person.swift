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
    let gender: Gender
    let currentProjectName: String
    
    enum Gender: Int {
        case male = 0
        case female = 1
    }
    
    static func JSONKeyPathByPropertyKey() -> [String: String] {
        return ["currentProjectName": "project.name"]
    }
    
    static func genderJSONTransformer(value: Int) -> Gender? {
        return Gender(rawValue: value)
    }
    
    static func projectsJSONTransformer(value: [[String: Any]]) -> [Project] {
        return value.flatMap(Project.parse)
    }
    
    static func dateJSONTransformer(value: Double) -> Date {
        return Date(timeIntervalSince1970: value)
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
        guard let id = (json["id"] as? Int),
			let name = (json["name"] as? String),
			let gender = (json["gender"] as? Int).flatMap(genderJSONTransformer),
			let currentProjectName = ((json["project"] as? [String: Any])?["name"] as? String) else { return nil }
        return Person(id: id, name: name, gender: gender, currentProjectName: currentProjectName)
    }
    static func parses(jsons: Any) -> [Person] {
        guard let jsons = jsons as? [[String: Any]] else { return [] }
        return jsons.flatMap(parse)
    }
}

extension Project {
    static func parse(json: Any) -> Project? {
        guard let json = json as? [String: Any] else { return nil }
        guard let name = (json["name"] as? String) else { return nil }
        return Project(name: name)
    }
    static func parses(jsons: Any) -> [Project] {
        guard let jsons = jsons as? [[String: Any]] else { return [] }
        return jsons.flatMap(parse)
    }
}

// JSONCop-End
