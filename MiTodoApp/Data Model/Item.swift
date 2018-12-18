//
//  Item.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 11/12/18.
//  Copyright © 2018 Fernando Borges Paul. All rights reserved.
//

import Foundation


// Class Item now can encode and decode itself in a plist
class Item: Codable{
    var title: String = ""
    var done: Bool = false
}
