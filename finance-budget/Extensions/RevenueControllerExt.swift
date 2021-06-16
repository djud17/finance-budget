//
//  ControllerExt.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

extension RevenueViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Задаем количество ячеек
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return revenueArrays.count
    }
    
    // Формируем ячейку и передаем данные в элементы ячейки
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "revenueCell")
        let model = revenueArrays[indexPath.row]
        
        cell?.textLabel?.text = model.revenueType
        cell?.detailTextLabel?.text = "+ " + separatedNumber(model.revenueValue) + " \u{20BD}"
        cell?.detailTextLabel?.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return cell!
    }
    
    // Добавляем возможность удаления ячейки и соответствующих данных
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Удалить") {(rowAction, indexPath) in
            let revenue = self.revenueArrays[indexPath.row]
            
            self.revenueArrays.remove(at: indexPath.row)
            self.currentBalance -= revenue.revenueValue
            
            Persistance.shared.balance = self.currentBalance
            Persistance.shared.realmDeleteRevenue(revenue)
            
            self.balanceLabel.text = self.separatedNumber(self.currentBalance) + " \u{20BD}"
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        return [deleteAction]
    }
    
}

extension RevenueViewController: AddRevenueDelegate {
    
    // Передаем данные с помощью делегата и добавляем в массив, формирующий таблицу
    // Запись дохода в Realm
    
    func addRevenueToTable(value: Int, type: String) {
        let revenue = Revenue()
        revenue.revenueValue = value
        revenue.revenueType = type
        
        currentBalance += value
        Persistance.shared.balance = currentBalance
        
        revenueArrays.append(revenue)
        Persistance.shared.realmWrite(revenue)
        
        balanceLabel.text = separatedNumber(currentBalance) + " \u{20BD}"
        revenueTableView.reloadData()
    }
}
