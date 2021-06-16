//
//  AddPurchaseViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 16.06.2021.
//

import UIKit

protocol AddPurchaseDelegate {
    func addPurchase(purchase: Purchase)
}

class AddPurchaseViewController: UIViewController {

    @IBOutlet weak var purchaseValueTextField: UITextField!
    @IBOutlet weak var purchaseAimTextField: UITextField!
    @IBOutlet weak var purchaseDatePicker: UIDatePicker!
    @IBOutlet weak var errorLabel: UILabel!
    
    var categoryName: String = ""
    var delegate: AddPurchaseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        moveIn()
    }
    
    @IBAction func addPurchaseBtnTapped(_ sender: Any) {
        if let purchaseValue = Int(purchaseValueTextField.text!),
           let purchaseAim = purchaseAimTextField.text,
           purchaseValueTextField.text != "",
           purchaseAimTextField.text != "" {
            let purchaseDate = shortDate(purchaseDatePicker.date.description)
            
            let newPurchase = Purchase()
            newPurchase.categoryName = categoryName
            newPurchase.purchaseAim = purchaseAim
            newPurchase.purchaseDate = purchaseDate
            newPurchase.purchaseValue = purchaseValue

            delegate?.addPurchase(purchase: newPurchase)
            moveOut()
        } else {
            errorLabel.isHidden = false
        }
    }
    
}
