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
        return category.purchases.count
    }
    
    // Формируем ячейку и передаем данные в элементы ячейки
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell") as! PurchaseTableViewCell
        let model = category.purchases[indexPath.row]
        
        cell.purchaseAimLabel.text = model.purchaseAim
        cell.purchaseDateLabel.text = model.purchaseDate
        cell.purchaseValueLabel.text = "- " + separatedNumber(model.purchaseValue) + " \u{20BD}"
        cell.purchaseValueLabel.textColor = #colorLiteral(red: 0.6235294342, green: 0.117264287, blue: 0.06386806873, alpha: 1)
        
        return cell
    }
    
    // Добавляем возможность удаления ячейки и соответствующих данных из Realm
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {(rowAction, indexPath) in
            let purchase = self.category.purchases[indexPath.row]
            
            self.category.purchases.remove(at: indexPath.row)
            Persistance.shared.realmDeletePurchase(purchase)
                      
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction]
    }
}

extension PurchaseListViewController: AddPurchaseDelegate {
    
    // Передаем данные с помощью делегата и добавляем в массив, формирующий таблицу категорий
    
    func addPurchase(purchase: Purchase) {
        category.purchases.append(purchase)
        Persistance.shared.realmWrite(purchase)
        purchaseListTableView.reloadData()
    }
}
