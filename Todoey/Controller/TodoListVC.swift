//
//  ViewController.swift
//  Todoey
//
//  Created by Apple on 06/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
class TodoListVC: SwipeTableVC {
    
    @IBOutlet weak var searchBar: UISearchBar!
    //MARK: - Constants
    let realm = try! Realm()
    var arrItem : Results<Item>?
    var index: Int?
    var selectedCategory: Category?{
        didSet{
            loaditem()
        }
    }
    
    //MARK: - View controller life cycles
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        tableView.separatorStyle = .none
        
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.colour{
            title = selectedCategory!.name
            guard let navbar = navigationController?.navigationBar else{
                fatalError("navbar not extst")
            }
            if let navbarColor = UIColor(hexString: colorHex){
                 
                navbar.backgroundColor = navbarColor
                navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
                navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navbarColor, returnFlat: true)]
                searchBar.barTintColor = navbarColor
               
        
            }
            
            
            
            
        }
        
    }
    //MARK: - Add new items
    
    @IBAction func btnAdd_clk(_ sender: UIBarButtonItem) {
        CreateAlert(flag: "New Item")
    }
    
    private func CreateAlert(flag : String){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                
                if flag == "New Item"{
                    let newItem = Item()
                    newItem.Rtitle = textField.text!
                    newItem.dateCreated = Date()
                    self.saveItems(in: currentCategory, with: newItem)
                }else{
                    if let ind = self.index, let item = self.arrItem?[ind] {
                        
                        self.updateItems(in: item, with: textField.text!)
                        
                        
                    }
                    
                }
                
                
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTxtFld) in
            alertTxtFld.placeholder = "Create new item"
            textField = alertTxtFld
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - Model manipulation methods
    
    func loaditem(){
        arrItem = selectedCategory?.items.sorted(byKeyPath: "Rtitle", ascending: true)
        tableView.reloadData()
        
    }
    func saveItems(in cuttrntCat : Category, with item : Item){
        do{
            try self.realm.write{
                cuttrntCat.items.append(item)
            }
        }catch{
            print(error)
        }
    }
    func updateItems(in item : Item, with text : String){
        
        do{
            try realm.write{
                item.Rtitle = text
            }
        }catch{
            
        }
    }
    func deleteItem(_ item: Item){
        do{
            try self.realm.write{
                self.realm.delete(item)
            }
        }catch{
            
        }
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
        if let item = self.arrItem?[indexPath.row]{
            
            self.deleteItem(item)
            
            
        }
    }
    
    
    
    
}

//MARK: - tableview datasource methods

extension TodoListVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = arrItem?[indexPath.row]{
            cell.textLabel?.text = item.Rtitle
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(arrItem!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            
            cell.accessoryType = item.Rdone ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No item added yet"
        }
        
        return cell
    }
}

//MARK: - Tableview Delegate Methods

extension TodoListVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //update data using realm
        if let item = arrItem?[indexPath.row]{
            
            do{
                try realm.write{
                    item.Rdone = !item.Rdone
                }
            }catch{
                
            }
            
        }
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //
    //        index = indexPath.row
    //
    //        // action one
    //        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
    //
    //            self.index = indexPath.row
    //
    //                do{
    //                    try self.realm.write{
    //                        self.CreateAlert(flag: "Edit")
    //
    //                    }
    //                }catch{
    //
    //                }
    //
    //            tableView.reloadData()
    //
    //
    //        })
    //        editAction.backgroundColor = UIColor.blue
    //
    //        // action two
    //        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
    //
    //            if let item = self.arrItem?[indexPath.row]{
    //
    //                self.deleteItem(item)
    //
    //
    //            }
    //            tableView.reloadData()
    //
    //
    //
    //        })
    //        deleteAction.backgroundColor = UIColor.red
    //
    //        return [deleteAction, editAction]
    //    }
}


//MARK: - UISearchbarDelegare

extension TodoListVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        arrItem = arrItem?.filter("Rtitle CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loaditem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
}
