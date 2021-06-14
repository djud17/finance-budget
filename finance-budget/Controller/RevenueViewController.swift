//
//  ViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 31.05.2021.
//

import UIKit

class RevenueViewController: UIViewController {

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var revenueTableView: UITableView!
    
    var currentBalance = 0
    
    var revenueArrays: [Revenue] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let revenueRealmArray = Persistance.shared.realmRead(),
           let newBalance = Persistance.shared.balance {
            for el in revenueRealmArray {
                revenueArrays.append(el)
            }
            revenueTableView.reloadData()
            balanceLabel.text = separatedNumber(newBalance) + " \u{20BD}"
        }
    }
    
    @IBAction func addRevenueBtnTapped(_ sender: Any) {
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCaddRevenue") as! AddRevenuePopUpViewController
        
        popUpVC.delegate = self

        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)

        popUpVC.didMove(toParent: self)
    }
    
    // Функция для отображения числа с разделением на десятки
    
    func separatedNumber(_ number: Any) -> String {
        guard let itIsANumber = number as? NSNumber else { return "Not a number" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        return formatter.string(from: itIsANumber)!
    }
    
}
