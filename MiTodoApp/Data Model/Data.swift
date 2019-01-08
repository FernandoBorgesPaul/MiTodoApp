//
//  Data.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 08/01/19.
//  Copyright © 2019 Fernando Borges Paul. All rights reserved.
//

import Foundation
import RealmSwift


class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
