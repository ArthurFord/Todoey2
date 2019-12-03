//
//  ViewController.swift
//  Todoey2
//
//  Created by Arthur Ford on 12/1/19.
//  Copyright © 2019 Arthur Ford. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    var selectedCategory: Category? {
        didSet {
            loadToDos()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        
        cell.textLabel!.text = items?[indexPath.row].task ?? "No items added yet"
        cell.accessoryType = items?[indexPath.row].isDone ?? false ? .checkmark : .none
        return cell
    }
    
    //MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try self.realm.write {
                items?[indexPath.row].isDone.toggle()
            }
        } catch  {
            print("error updating isDone property")
        }
        
        
        if (items?[indexPath.row].isDone ?? false) {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    //MARK:- Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when user clicks add itme button on the alert
            if textField.text != "" {

                let newItem = Item()
                newItem.task = textField.text!
                
                do {
                    try self.realm.write {
                        self.selectedCategory?.items.append(newItem)
                        self.realm.add(newItem)
                    }
                } catch {
                    print(error)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
    
    func loadToDos() {

        items = selectedCategory?.items.sorted(byKeyPath: "createDate", ascending: true)
        tableView.reloadData()
    }
}
//MARK: - UISearchBar

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        let predicate = NSPredicate(format: "task CONTAINS[cd] %@", searchBar.text!)
        items = realm.objects(Item.self).filter(predicate).sorted(byKeyPath: "createDate", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadToDos()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
