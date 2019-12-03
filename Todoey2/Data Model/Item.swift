//
//  Item.swift
//  Todoey2
//
//  Created by Arthur Ford on 12/3/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var task: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var createDate = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
