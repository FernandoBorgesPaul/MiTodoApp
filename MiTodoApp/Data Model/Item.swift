//
//  Item.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 08/01/19.
//  Copyright © 2019 Fernando Borges Paul. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")        //Define the inverse relationship with
                                                                                           //the Category Class. 
}
