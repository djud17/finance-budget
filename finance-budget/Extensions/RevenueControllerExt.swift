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
        if revenueArrays.count == 0 {
            tableView.setEmptyMessage("Нет записей о доходах")
        } else {
            tableView.restore()
        }

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
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let revenue = self.revenueArrays[indexPath.row]
            
            self.revenueArrays.remove(at: indexPath.row)
            self.currentBalance -= revenue.revenueValue
            
            Persistance.shared.balance = self.currentBalance
            Persistance.shared.realmDeleteRevenue(revenue)
            
            self.balanceLabel.text = self.separatedNumber(self.currentBalance) + " \u{20BD}"
            self.balanceLabel.shake()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
        balanceLabel.shake()
        revenueTableView.reloadData()
    }
}
