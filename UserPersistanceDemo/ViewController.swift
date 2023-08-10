//
//  ViewController.swift
//  UserPersistanceDemo
//
//  Created by Kodeeshwari Solanki on 2023-08-10.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    //    var itemArray:[String] = ["Buy Eggs","Do Grocery","Shopping List"]
    //    var defaults = UserDefaults.standard
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let newItem = Item()
        newItem.title = "Buy Eggs"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Do Grocery"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Shopping List"
        itemArray.append(newItem3)
        
        loadItems()
        
        //        if let items = defaults.array(forKey: "TodoArray") as? [Item]{
        //            itemArray = items
        //        }
    }
    
    
    @IBAction func btnAddPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { alertTextFeild in
            alertTextFeild.placeholder = "Create New Item"
            textField = alertTextFeild
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let userInput = textField.text?.capitalized {
                
                let newItem = Item()
                newItem.title = userInput
                self.itemArray.append(newItem)
                
                
                //                self.defaults.setValue(self.itemArray, forKey: "TodoArray")
                self.saveItems()
                
            }
            else{
                print("Textfield should not be empty")
            }
            
        }
        alert.addAction(action)
        
        present(alert, animated: true,completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//         using selected row
//         if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
//         tableView.cellForRow(at: indexPath)?.accessoryType = .none
//         }
//         else{
//         tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//         }
//
//
//        using content of cell
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch{
            print("error while encoding array \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("error while decoding data from .plist")
            }
        }
    }
}

