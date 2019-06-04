//
//  ViewController.swift
//  Todoey
//
//  Created by Sai Emani on 6/3/19.
//  Copyright © 2019 Sai Emani. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var sampleItems = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadItems()
    }
    
    //MARK: Table View Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = sampleItems[indexPath.row].title
        cell.accessoryType = sampleItems[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: Table View Delegate Mehtods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = sampleItems[indexPath.row]
        
        todo.done = !todo.done
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }

    // MARK: Add Todo Item Action
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text ?? "New Item"
            newItem.done = false
            self.sampleItems.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK : Core Data Save and Read Methods
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            sampleItems = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("error fetching data from context \(error)")
        }
    }
}

// MARK : UISearchBar Delegate methods
extension TodoListViewController : UISearchBarDelegate {
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
       loadItems(with : request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count == 0) {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

