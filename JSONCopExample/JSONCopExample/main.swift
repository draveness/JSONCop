//
//  main.swift
//  JSONCopExample
//
//  Created by Draveness on 9/20/16.
//  Copyright © 2016 Draveness. All rights reserved.
//

import Foundation

let antherJSON = [
    "id": 1,
    "name": "draven",
    "date": NSTimeIntervalSince1970,
    "gender": 1,
    "project": [
        "name":"project-1"
    ]
] as [String : Any]

print(Person.parse(json: antherJSON))
