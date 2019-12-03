//
//  Category.swift
//  Todoey2
//
//  Created by Arthur Ford on 12/3/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    let items = List<Item>()
}
