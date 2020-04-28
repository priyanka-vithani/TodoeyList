//
//  CategoryVC.swift
//  Todoey
//
//  Created by Apple on 13/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryVC: SwipeTableVC {
    
    //MARK: - constants
    let realm = try! Realm()
    var arrCatrgory : Results<Category>?
    var index : Int?
    
    //MARK: - viewcontroller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        guard let navbar = navigationController?.navigationBar else{
                       fatalError("navbar not extst")
                   }
        navbar.backgroundColor = UIColor(hexString: "0984FF")
    }
    //MARK: - add new categories
    @IBAction func btnAdd_clk(_ sender: UIBarButtonItem) {
        CreateAlert(flag: "New Item")
    }
    private func CreateAlert(flag : String){
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            
            if textField.text != ""{
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colour = UIColor.randomFlat().hexValue()
                self.saveRealm(catrgory: newCategory)
                
            }
            
        }
        alert.addAction(action)
        alert.addTextField { (alertTxtFld) in
            alertTxtFld.placeholder = "Add new category"
            textField = alertTxtFld
        }
        
        present(alert, animated: true, completion: nil)
        
    }

    
    //MARK: - data manipulation
    
 
    func  loadCategories(){
           
           arrCatrgory = realm.objects(Category.self)
           
           tableView.reloadData()
           
       }
       func saveRealm(catrgory: Category){
           do {
               try realm.write{
                   realm.add(catrgory)
               }
           }catch{
               
           }
           tableView.reloadData()
       }
       
       func deleteCategory(_ category : Category){
           do{
               try self.realm.write{
                   self.realm.delete(category)
               }
           }catch{
               
           }
       }
       
       override func updateModel(at indexPath: IndexPath) {
        super.updateModel(at: indexPath)
           if let category = self.arrCatrgory?[indexPath.row]{
               
               self.deleteCategory(category)
           }
       }
    
    
}
//MARK: - TABLEVIEW DATADOURCE METHODS
extension CategoryVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCatrgory?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = arrCatrgory?[indexPath.row]{
            cell.textLabel?.text = category.name
           
            
            guard let categoryColor = UIColor(hexString: category.colour) else {
                fatalError()
            }
             cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }else{
            cell.textLabel?.text = "No categories added yet"
                     cell.backgroundColor = UIColor(hexString: "0984FF")
        }
        
        return cell
    }
    
}


//MARK: - tableview delegate methods
extension CategoryVC{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = arrCatrgory?[indexpath.row]
        }
    }
}








