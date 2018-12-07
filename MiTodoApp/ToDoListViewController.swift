//
//  ViewController.swift
//  MiTodoApp
//
//  Created by Fernando Borges Paul on 05/12/18.
//  Copyright © 2018 Fernando Borges Paul. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy eggos", "Destroy the demogorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        

    }

    
    //MARK: - Tableview DataSource Methods
    
    // Se crea el número de filas de la tableView con base a itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    // Se crean las filas y se llenan con los datos que contiene cada fila con el indexPath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row) // Imprimirá el número de la fila que se eligió.
        print(itemArray[indexPath.row]) // Imprime ahora el valor contenido en cada fila de acuerdo al indexPath
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark  // Se agrega signo de checkmark al seleccionar la fila
        
        // Si la fila esta seleccionada , al apretar se quita la marca, sino se vuelve a colocar.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
}

