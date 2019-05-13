//
//  ViewController.swift
//  Todoey
//
//  Created by Pooja on 12/05/19.
//  Copyright © 2019 Pooja. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var tableData = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let item = Item()
        item.itemName = "Go to Office"
        tableData.append(item)
        
        let item2 = Item()
        item2.itemName = "Work"
        tableData.append(item2)
        
        let item3 = Item()
        item3.itemName = "Buy Vegetables"
        tableData.append(item3)
        
        let item4 = Item()
        item4.itemName = "Cook"
        tableData.append(item4)
        
    }
    
    // UITableViewDataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row].itemName
        return cell
    }
    
    // UITableViewDelegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableData[indexPath.row].done = !tableData[indexPath.row].done
        if tableData[indexPath.row].done {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add New Items
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        var uitextField = UITextField()
        let uiAlertController = UIAlertController(title: "Add Item", message: "Add your item here:", preferredStyle: .alert)
        let uiAlertButton = UIAlertAction(title: "OK", style: .default, handler: { action in
            if uitextField.text! != "" {
                let newItem = Item()
                newItem.itemName = uitextField.text!
                self.tableData.append(newItem)
                self.tableView.reloadData()
            } else {
                print("Empty string found!!!")
            }
        })
        
        uiAlertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "Type New Item"
            uitextField = textField
        })
        uiAlertController.addAction(uiAlertButton)
        self.present(uiAlertController, animated: true, completion: nil)
    }
    
}

