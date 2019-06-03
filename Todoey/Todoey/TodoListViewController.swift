//
//  ViewController.swift
//  Todoey
//
//  Created by Sai Emani on 6/3/19.
//  Copyright © 2019 Sai Emani. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var sampleItems = ["Buy Eggos", "Save the world", "Meditate"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Table View Data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        cell.textLabel?.text = sampleItems[indexPath.row]
        return cell
    }
    
    // MARK: Table View Delegate Mehtods


}

