//
//  ViewController.swift
//  Todoey
//
//  Created by Apple on 06/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    
    //MARK: - Constants
    
    var arrItem = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //MARK: - View controller life cycles
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath!)
        loadItems()
       
    }
    
    
}

//MARK: - tableview datasource methods

extension TodoListVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let item = arrItem[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
}
//MARK: - Tableview Delegate Methods

extension TodoListVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(arrItem[indexPath.row])
        arrItem[indexPath.row].done = !arrItem[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}
//MARK: - Add new items
extension TodoListVC{
    
    @IBAction func btnAdd_clk(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != ""{
                let newItem = Item()
                newItem.title = textField.text!
                self.arrItem.append(newItem)
                
                self.saveItems()
                
            }
            
        }
        alert.addTextField { (alertTxtFld) in
            alertTxtFld.placeholder = "Create new item"
            textField = alertTxtFld
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}


 //MARK: - Model manipulation methods
extension TodoListVC{
       
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(arrItem)
            try data.write(to: dataFilePath!)
            
        }catch{
            print("Error encoding item array")
        }
        tableView.reloadData()
    }
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
             let decoder = PropertyListDecoder()
            do{
                arrItem = try decoder.decode([Item].self, from: data)
                
            }catch{
                print("catch error")
            }
            
        }
    }
}
