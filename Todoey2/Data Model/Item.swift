//
//  Item.swift
//  Todoey2
//
//  Created by Arthur Ford on 12/1/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation

struct Item: Codable {
    var task: String
    var isDone: Bool = false
}
