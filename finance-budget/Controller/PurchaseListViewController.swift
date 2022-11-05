//
//  PurchaseListViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 15.06.2021.
//

import UIKit

class PurchaseListViewController: UIViewController {
    
    // Экран Расходов
    
    @IBOutlet weak var purchaseListTableView: UITableView!
    
    var category = Category()
    var currency = " \u{20BD}"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category.categoryName
        navigationItem.backButtonTitle = "Расходы"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        purchaseListTableView.allowsSelection = false
        purchaseListTableView.tableFooterView = UIView()
        
        // Подгрузка данных из памяти
        
        if let purchasesRealmArray = Persistance.shared.realmReadPurchase(category.categoryName){
            category.purchases.removeAll()
            for el in purchasesRealmArray {
                category.purchases.append(el)
            }
            purchaseListTableView.reloadData()
        }
    }

    @IBAction func purchaseGraph(_ sender: Any) {
        // Переход к экрану с графиками расходов по текущей категории
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "graphRevenue") as! GraphRevenuesViewController
        
        vc.category = category

        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addPurchase(_ sender: Any) {
        
        // Вызов всплывающего окна для добавления расхода
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCaddPurchase") as! AddPurchaseViewController
        
        popUpVC.categoryName = category.categoryName
        popUpVC.delegate = self

        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)

        popUpVC.didMove(toParent: self)
    }
    
}

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
