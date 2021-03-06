//
//  PurchaseListControllerExt.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 16.06.2021.
//

import UIKit

extension PurchaseListViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Задаем количество ячеек
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if category.purchases.count == 0 {
            tableView.setEmptyMessage("Нет записей о расходах")
        } else {
            tableView.restore()
        }
        
        return category.purchases.count
    }
    
    // Формируем ячейку и передаем данные в элементы ячейки
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell") as! PurchaseTableViewCell
        let model = category.purchases[indexPath.row]
        
        cell.purchaseAimLabel.text = model.purchaseAim
        cell.purchaseDateLabel.text = model.purchaseDate
        cell.purchaseValueLabel.text = "- " + separatedNumber(model.purchaseValue) + currency
        cell.purchaseValueLabel.textColor = #colorLiteral(red: 0.6235294342, green: 0.117264287, blue: 0.06386806873, alpha: 1)
        
        return cell
    }
    
    // Добавляем возможность удаления ячейки и соответствующих данных из Realm

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let purchase = self.category.purchases[indexPath.row]
            
            if var balance = Persistance.shared.balance {
                balance += purchase.purchaseValue
                Persistance.shared.balance = balance
            }
            
            self.category.purchases.remove(at: indexPath.row)
            Persistance.shared.realmDeletePurchase(purchase)
                      
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension PurchaseListViewController: AddPurchaseDelegate {
    
    // Передаем данные с помощью делегата и добавляем в массив, формирующий таблицу категорий
    
    func addPurchase(purchase: Purchase) {
        category.purchases.append(purchase)
        Persistance.shared.realmWrite(purchase)
        
        if var balance = Persistance.shared.balance {
            balance -= purchase.purchaseValue
            Persistance.shared.balance = balance
        }
        
        purchaseListTableView.reloadData()
    }
}
