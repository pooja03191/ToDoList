//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Pooja on 17/05/19.
//  Copyright © 2019 Pooja. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    // MARK: Add New Category
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        let uiAlertController = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        var uiTextField = UITextField()
        uiAlertController.addTextField(configurationHandler: {textField in
            textField.placeholder = "Type Category here..."
            uiTextField = textField
        })
        let uiAlertAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            let newCategory = Category(context: self.context)
            newCategory.name = uiTextField.text!
            
            self.saveCategory()
            self.categoryArray.append(newCategory)
            self.tableView.reloadData()
        })
        
        uiAlertController.addAction(uiAlertAction)
        self.present(uiAlertController, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDatasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    // MARK: UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    // MARK: Model Handling Methods
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error while saving data \(error)")
        }
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error while loading the data \(error)")
        }
        
        tableView.reloadData()
    }
}
