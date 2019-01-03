//
//  CategoryViewController.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 02/01/19.
//  Copyright © 2019 Fernando Borges Paul. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        
    }
    
    //MARK: - TableView Datasource Methods
    
    //Number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        cell.textLabel?.text = categoryArray[indexPath.row].name    // The cell get their name fmor the categoryArray
        
        return cell
    }
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    func loadCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching the request \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    //MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)   //Initialize the new category
            newCategory.name = textField.text!                  // The new category gets the name form the textField.
            
            self.categoryArray.append( newCategory)            // teh new category is appended to the array.
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    //MARK: - Tableview Delegate Methods
    
    //This method gets triggered when user press one of the categories and passes to the
    // coresponding list of items in the ToDoListViewController
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // This method determines the destination ViewController corresponding to the seleted cell
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        //indexPathForSelectedRow takes the specific row and assigns it to a specific indexPath
        if  let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
        
    }
    
    
    
}
