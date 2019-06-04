//
//  CategoryListTableViewController.swift
//  Todoey
//
//  Created by Sai Emani on 6/4/19.
//  Copyright © 2019 Sai Emani. All rights reserved.
//

import UIKit
import CoreData

class CategoryListTableViewController: UITableViewController {
    
    var categoryList = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()
    }
    
    // MARK : TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryListCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name
        
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
            destinationVC.selectedCategory = categoryList[selectedIndex.row]
        }
    }
    
    // MARK : VC Actions
    @IBAction func addCategoryClicked(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        
        let alert = UIAlertController(title: "Add a new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            alertTextField = textField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = alertTextField.text ?? "New category"
            
            self.categoryList.append(newCategory)
            
            self.saveCategory()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK : Core Data Methods
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving category data: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategoryData() {
        do {
            let request : NSFetchRequest<Category> = Category.fetchRequest()
            categoryList = try context.fetch(request)
        } catch {
            print("Error fetch category data: \(error)")
        }
        tableView.reloadData()
    }
    

}
