//
//  Item.swift
//  Todoey
//
//  Created by Sai Emani on 6/4/19.
//  Copyright © 2019 Sai Emani. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    // Type and property is the name of the forward relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
