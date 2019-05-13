//
//  ViewController.swift
//  Todoey
//
//  Created by Pooja on 12/05/19.
//  Copyright © 2019 Pooja. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var tableData = ["Goo to Office", "Cook Food", "Study", "Sleep"]
    var defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            tableData = items
        }
    }
    
    // UITableViewDataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }
    
    // UITableViewDelegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableData[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add New Items
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        var uitextField = UITextField()
        let uiAlertController = UIAlertController(title: "Add Item", message: "Add your item here:", preferredStyle: .alert)
        let uiAlertButton = UIAlertAction(title: "OK", style: .default, handler: { action in
            if uitextField.text! != "" {
                self.tableData.append(uitextField.text!)
                self.tableView.reloadData()
                
                self.defaults.set(self.tableData, forKey: "ToDoListArray")
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

