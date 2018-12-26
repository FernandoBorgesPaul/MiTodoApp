//
//  ViewController.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 05/12/18.
//  Copyright © 2018 Fernando Borges Paul. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // DataFilePath is created to access the local data in the users memory through a documents directory and will append the new data in a file called Items.plist
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                loadItems()
        
//                if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//                    itemArray = items
//                }
        
        
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
        
        saveItems() // Function to save items
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    // MARK: - Add new items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //This var will help to access the textField as a local variable. 
        var textField = UITextField()
        
        //Alert launched after pressing the addButton
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // We create the context that will be taken as the AppDelegate
            
            //What happens when the user clicks in the Add Item button on our UIAlert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false             // Initialize each Item as false
            self.itemArray.append(newItem)   // The array will get all items from the New Item Instance
            
            self.saveItems()
            
        }
        // Add a textField for the user to type his reminders.
        alert.addTextField{ (alertTextField) in
            alertTextField.placeholder = "Create a new Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
        
        
    }
    
    // MARK: - Model Manipulation Method
    
    func saveItems() {
        
        do {
            
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        
        // New data appended will appear in the tableView reloading the data.
        self.tableView.reloadData()
    }
    
    //Read the data.
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest() // Makes the request of Items
        do {
         itemArray = try context.fetch(request) // results will be saved in the itemArray declared previously.
        } catch {
            print("Error fetching data from context \(error)")
        }
        
    }
}
