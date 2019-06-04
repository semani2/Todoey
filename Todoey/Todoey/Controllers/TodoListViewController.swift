//
//  ViewController.swift
//  Todoey
//
//  Created by Sai Emani on 6/3/19.
//  Copyright © 2019 Sai Emani. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var sampleItems = [Todo]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArrayNew") as? [Todo] {
            sampleItems = items
        } else {
            let newTodo = Todo()
            newTodo.title = "FInd Mike"
            sampleItems.append(newTodo)
        }
    }
    
    //MARK: Table View Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = sampleItems[indexPath.row].title
        cell.accessoryType = sampleItems[indexPath.row].isDone ? .checkmark : .none
        
        return cell
    }
    
    // MARK: Table View Delegate Mehtods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = sampleItems[indexPath.row]
        
        todo.isDone = !todo.isDone
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    // MARK: Add Todo Item Action
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Todo()
            newItem.title = textField.text ?? "New Item"
            
            self.sampleItems.append(newItem)
            
            self.defaults.set(self.sampleItems, forKey: "TodoListArrayNew")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

