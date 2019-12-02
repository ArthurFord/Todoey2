//
//  ViewController.swift
//  Todoey2
//
//  Created by Arthur Ford on 12/1/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray:[Item] = []
    let encoder = PropertyListEncoder()
    let decoder = PropertyListDecoder()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Todoey.plist")
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadToDos()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel!.text = itemArray[indexPath.row].task
        cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark : .none
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemArray[indexPath.row].isDone.toggle()
        
        if (itemArray[indexPath.row].isDone) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        self.saveToDos()
    }
    
    //MARK:- Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add itme button on the alert
            if textField.text != "" {
                self.itemArray.append(Item(task: textField.text!))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.saveToDos()
            }

        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    //MARK: - Model manipulation methods
    
    func saveToDos() {
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Data not saved")
        }
    }

    func loadToDos() {
        do {
            let data = try Data(contentsOf: dataFilePath!)
            itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Broken load")
            
        }
        
    }

    
}
