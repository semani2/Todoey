//
//  CategoryListTableViewController.swift
//  Todoey
//
//  Created by Sai Emani on 6/4/19.
//  Copyright © 2019 Sai Emani. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryListTableViewController: UITableViewController {
    
    var categories: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()
        
        tableView.rowHeight = 80
    }
    
    // MARK : TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        cell.delegate = self
        
        return cell
    }
    
    // MARK : TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "todoListSeque", sender: self)
    }
    
    // MARK : Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let selectedIndex = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[selectedIndex.row]
        }
    }
    
    // MARK : VC Actions
    @IBAction func addCategoryClicked(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            alertTextField = textField
            textField.placeholder = "Category name"
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = alertTextField.text ?? "New category"
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK : Core Data Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category data: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategoryData() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    

}

// MARK : Swipe cell delegate methods
extension CategoryListTableViewController : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let category = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(category)
                    }
                } catch {
                    print("Error deleting category \(error)")
                }
            }
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

}
