//
//  PurchasesCategoriesViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

class PurchasesCategoriesViewController: UIViewController {
    
    // Экран Категории расходов

    @IBOutlet weak var categoryTableView: UITableView!
    
    var categoryArray: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Расходы"
        navigationItem.backButtonTitle = "Категории"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        categoryTableView.tableFooterView = UIView()
        
        // Подгрузка данных из памяти
        
        if let categoriesRealmArray = Persistance.shared.realmReadCategory(){
            for el in categoriesRealmArray {
                let category = Category()
                category.categoryName = el.categoryName
                categoryArray.append(category)
            }
            categoryTableView.reloadData()
        }
    }
    
    @IBAction func addCategory(_ sender: Any) {
        
        // Вызов всплывающего окна для добавления категории
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCaddCategory") as! AddCategoryPopUpViewController
        
        popUpVC.delegate = self

        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)

        popUpVC.didMove(toParent: self)
    }
    
}

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
