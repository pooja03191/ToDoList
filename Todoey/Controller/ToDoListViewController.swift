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
    
    // File path for custom plist file.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadData()
        
    }
    
    // MARK: UITableViewDataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let item = tableData[indexPath.row]
        cell.textLabel?.text = item.itemName
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    // MARK: UITableViewDelegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableData[indexPath.row].done = !tableData[indexPath.row].done
        saveData()
        tableView.reloadData()
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
                self.saveData()
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
    
    // MARK: Model Handling Methods
    
    // Saving data by encoding it to PropertyList format
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(tableData)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error while encoding data \(error)")
        }
    }
    
    // Fetching data by decoding PropertyList format to Item array
    func loadData() {
        let decoder = PropertyListDecoder()
        if let data = try? Data(contentsOf: dataFilePath!) {
            do
            {
              tableData = try decoder.decode([Item].self, from: data)
            } catch {
                print("Deoding Error \(error)")
            }
        }
    }
}

