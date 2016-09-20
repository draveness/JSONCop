//
//  main.swift
//  JSONCopExample
//
//  Created by Draveness on 9/20/16.
//  Copyright © 2016 Draveness. All rights reserved.
//

import Foundation

let json = [
    "id": 1,
    "name": "draven",
    "projects": [
        ["name":"project-1"],
        ["name":"project-2"],
        ["name":"project-3"]
    ]
] as [String : Any]

print(Person.parse(json: json))
