//
//  ViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 31.05.2021.
//

import UIKit

class RevenueViewController: UIViewController {
    
    // Экран Доходов

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var revenueTableView: UITableView!
    
    var currentBalance = 0
    var revenueArrays: [Revenue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Подгрузка данных из памяти
        
        if let revenueRealmArray = Persistance.shared.realmReadRevenue(),
           let newBalance = Persistance.shared.balance {
            for el in revenueRealmArray {
                revenueArrays.append(el)
            }
            revenueTableView.reloadData()
            currentBalance = newBalance
            balanceLabel.text = separatedNumber(newBalance) + " \u{20BD}"
        }
    }
    
    @IBAction func addRevenueBtnTapped(_ sender: Any) {
        
        // Вызов всплывающего окна для добавления дохода
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCaddRevenue") as! AddRevenuePopUpViewController
        popUpVC.delegate = self

        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)

        popUpVC.didMove(toParent: self)
    }
}
