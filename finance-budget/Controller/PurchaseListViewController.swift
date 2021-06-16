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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category.categoryName
        navigationItem.backButtonTitle = "Расходы"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Подгрузка данных из памяти
        
        if let purchasesRealmArray = Persistance.shared.realmReadPurchase(category.categoryName){
            category.purchases.removeAll()
            for el in purchasesRealmArray {
                category.purchases.append(el)
            }
            purchaseListTableView.reloadData()
        }
    }

    @IBAction func purchaseGraphBtnTapped(_ sender: Any) {
        // Переход к экрану с графиками расходов по текущей категории
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "graphRevenue") as! GraphRevenuesViewController
        
        vc.category = category

        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func addPurchaseBtnTapped(_ sender: Any) {
        
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
