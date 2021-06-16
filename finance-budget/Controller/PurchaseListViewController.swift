//
//  PurchaseListViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 15.06.2021.
//

import UIKit

class PurchaseListViewController: UIViewController {
    
    @IBOutlet weak var purchaseListTableView: UITableView!
    
    var category = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category.categoryName
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let purchasesRealmArray = Persistance.shared.realmReadPurchase(category.categoryName){
            for el in purchasesRealmArray {
                category.purchases.append(el)
            }
            purchaseListTableView.reloadData()
        }
    }

    @IBAction func purchaseGraphBtnTapped(_ sender: Any) {
    }
    
    @IBAction func addPurchaseBtnTapped(_ sender: Any) {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCaddPurchase") as! AddPurchaseViewController
        
        popUpVC.categoryName = category.categoryName
        popUpVC.delegate = self

        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)

        popUpVC.didMove(toParent: self)
    }
    
}
