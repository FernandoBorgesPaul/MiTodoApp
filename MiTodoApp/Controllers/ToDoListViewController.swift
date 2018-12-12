//
//  ViewController.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 05/12/18.
//  Copyright © 2018 Fernando Borges Paul. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Crear Blog"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Crear Facebook"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Crear Instagram "
        itemArray.append(newItem3)
        
        let newItem4 = Item()
        newItem4.title = "Crear Twitter"
        itemArray.append(newItem4)
        
        let newItem5 = Item()
        newItem5.title = "Visita www.borpaul.com"
        itemArray.append(newItem5)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        }
       
    }

    
    //MARK: - Tableview DataSource Methods
    
    // Se crea el número de filas de la tableView con base a itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // Se crean las filas y se llenan con los datos que contiene cada fila con el indexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator
        // value = contidion ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        // Another form to add the checkmark or none to the Items on every row.
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // Conditional to make the item true/false if its true
                                                                       //changes to false and viceversa.
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    // MARK: - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //This var will help to access the textField as a local variable. 
        var textField = UITextField()
        
        //Alert launched after pressing the addButton
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //What happens when the user clicks in the Add Item button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)   // The array will get all items from the New Item Instance
            self.defaults.set(self.itemArray, forKey: "ToDoListArray") // Eaxmple of Persisting data
            // New data appended will appear in the tableView reloading the data.
            self.tableView.reloadData()
        }
           // Add a textField for the user to type his reminders.
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create a new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
        
        
    }
        
        
}
    


