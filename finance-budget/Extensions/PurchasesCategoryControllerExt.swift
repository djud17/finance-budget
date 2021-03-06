//
//  PurchasesCategoryExt.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

extension PurchasesCategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Задаем количество ячеек
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoryArray.count == 0 {
            tableView.setEmptyMessage("Нет записей о категориях")
        } else {
            tableView.restore()
        }
        
        return categoryArray.count
    }
    
    // Формируем ячейку и передаем данные в элементы ячейки
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell")
        let model = categoryArray[indexPath.row]
        
        cell?.textLabel?.text = model.categoryName
        
        return cell!
    }
    
    // Добавляем возможность удаления ячейки и соответствующих данных из Realm (удаление всех покупок из памяти, принадлежащих данной категории)
 
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let category = self.categoryArray[indexPath.row]
            
            if let purchasesRealmArray = Persistance.shared.realmReadPurchase(category.categoryName){
                for el in purchasesRealmArray {
                    if var balance = Persistance.shared.balance {
                        balance += el.purchaseValue
                        Persistance.shared.balance = balance
                    }
                    
                    Persistance.shared.realmDeletePurchase(el)
                }
            }
            
            self.categoryArray[indexPath.row].purchases.removeAll()
            self.categoryArray.remove(at: indexPath.row)
            Persistance.shared.realmDeleteCategory(category)
                      
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // Реализация перехода из таблицы в выбранную категорию
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "purchaseStoryboard") as! PurchaseListViewController
        
        viewController.category = categoryArray[indexPath.row]
        
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PurchasesCategoriesViewController: AddCategoryDelegate {
    
    // Передаем данные с помощью делегата и добавляем в массив, формирующий таблицу категорий
    // Запись категорий в Realm

    func addCategory(categoryName: String) {
        let category = Category()
        category.categoryName = categoryName
        categoryArray.append(category)
        
        Persistance.shared.realmWrite(category)
        categoryTableView.reloadData()
    }
}
