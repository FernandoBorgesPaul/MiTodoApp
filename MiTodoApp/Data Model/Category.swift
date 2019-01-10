//
//  Category.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 08/01/19.
//  Copyright © 2019 Fernando Borges Paul. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""  // Dynamic means you can track changes while the app is running in simulator.
    let items = List<Item>()            // List are the way you declared relationships using the Realm Framework.
    
}
