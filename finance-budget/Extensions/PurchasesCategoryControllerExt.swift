//
//  PurchasesCategoryExt.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

extension PurchasesCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        let model = categoryArray[indexPath.row]
        
        cell?.textLabel?.text = model.categoryName
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {(rowAction, indexPath) in
            let category = self.categoryArray[indexPath.row]

            if !category.purchases.isEmpty {
                print("start")
                for el in category.purchases{
                    Persistance.shared.realmDeletePurchase(el)
                }
            }
            self.categoryArray.remove(at: indexPath.row)
            Persistance.shared.realmDeleteCategory(category)
                      
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "purchaseStoryboard") as! PurchaseListViewController
        
        viewController.category = categoryArray[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PurchasesCategoriesViewController: AddCategoryDelegate {
    func addCategory(categoryName: String) {
        let category = Category()
        category.categoryName = categoryName
        categoryArray.append(category)
        
        Persistance.shared.realmWrite(category)
        categoryTableView.reloadData()
    }
}
