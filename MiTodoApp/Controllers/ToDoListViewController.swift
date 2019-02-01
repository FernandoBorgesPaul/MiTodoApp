//
//  ViewController.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 05/12/18.
//  Copyright © 2018 Fernando Borges Paul. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {      // When this selectedCategory gets created it will call the Items for that specific
                                           // Category.
        didSet {                           // didSet , everything between the curly braces is going to happen as soon as
            // selectedCategory gets set with a value.
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //The title of the viewController will have the same name as the category you selected.
        title = selectedCategory?.name
        
        
        
        //Set the navigation controller to have the same color as the selected category.
           guard let colourHex = selectedCategory?.colour  else { fatalError()}
    
        updateNavBar(withHexCode: colourHex)
        
    }
    
    //View Vill disappear will take back the original colour of the navigator once you leave the ToDoViewController, otherwise
    // The CategoryViewController will have the same colour as the previous ToDoViewController
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D9BF6")
        
    }
    
    // MARK:- Nav Bar Set up Methods
    
    func updateNavBar(withHexCode colourHexCode: String){
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        // we guard this variable and if the nagivation controller exists, then it sets its colour into the same as the selected category.
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError()}
        
        navBar.barTintColor = navBarColour
        //Contrast the buttons in the navigation bar.
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        // This will contrast colour of the text from the navigation Title considering the navigation bar Colour to its contrast.
        // This made the BACK BUTTON and ADD BUTTON to have a contrast:
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        
        // Search Bar gets the colour from the navigation Bar.
        searchBar.barTintColor = navBarColour
        
    }
    
    
    //MARK: - Tableview DataSource Methods
    
    // Se crea el número de filas de la tableView con base a itemArray
    // Creates the number of row according to the itemArray.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    // Se crean las filas y se llenan con los datos que contiene cada fila con el indexPath
    //Creates the rows and fills them using the data on each row with the indexPath.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            //If we don't have an empty category row, then darken the colour to the porcentage from the division. 
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoItems!.count)) {
                
                cell.backgroundColor = colour
                
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true) // This makes the text in the cell have a contrast color in order to avoid not a good match of colours between the cell and the text.
                
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
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
            
            if let currectCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currectCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
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
    
    // MARK: - Model Manipulation Method
    
    
    
    //Read the data.
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting items \(error)")
            }
        }
    }
    
}
//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {               // Ask the dispatch to get the main queue and run this method on it
                
                searchBar.resignFirstResponder()     // Go to the original state, when you stop searching some words.
            }
        }
    }
    
}


