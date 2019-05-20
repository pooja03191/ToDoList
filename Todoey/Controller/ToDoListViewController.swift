//
//  ViewController.swift
//  Todoey
//
//  Created by Pooja on 12/05/19.
//  Copyright © 2019 Pooja. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var tableData = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadData()
        }
    }
    
    // File path for custom plist file.
    // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: UITableViewDataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        let item = tableData[indexPath.row]
        cell.textLabel?.text = item.title
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
                let newItem = Item(context: self.context)
                
                newItem.title = uitextField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
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
    func saveData() {
        
        // Saving data by encoding it to PropertyList format
        //        let encoder = PropertyListEncoder()
        //
        //        do {
        //            let data = try encoder.encode(tableData)
        //            try data.write(to: dataFilePath!)
        //        } catch {
        //            print("Error while encoding data \(error)")
        //        }
        
        // Saving data using Core data
        do {
            try context.save()
        } catch {
            let error = error as NSError
            print("Error while saving the data: \(error.userInfo)")
        }
    }
    
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
        // Fetching data by decoding PropertyList format to Item array
        //        let decoder = PropertyListDecoder()
        //        if let data = try? Data(contentsOf: dataFilePath!) {
        //            do
        //            {
        //              tableData = try decoder.decode([Item].self, from: data)
        //            } catch {
        //                print("Deoding Error \(error)")
        //            }
        //        }
        
        // Fetching data using Core data.
        print(selectedCategory!.name!)
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate
        do {
            tableData = try context.fetch(request)
            print(tableData)
        } catch {
            let error = error as NSError
            print("Error while loading data \(error.userInfo)")
        }
        tableView.reloadData()
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadData(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

