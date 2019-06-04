//
//  Category.swift
//  Todoey
//
//  Created by Sai Emani on 6/4/19.
//  Copyright © 2019 Sai Emani. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    
    let items = List<Item>()
}
