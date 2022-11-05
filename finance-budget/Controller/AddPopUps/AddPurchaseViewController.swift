//
//  AddPurchaseViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 16.06.2021.
//

import UIKit

protocol AddPurchaseDelegate: AnyObject {
    func addPurchase(purchase: Purchase)
}

class AddPurchaseViewController: UIViewController {
    
    // Всплывающий экран для добавления нового расхода

    @IBOutlet weak var popUpView: CustomView!
    @IBOutlet weak var purchaseValueTextField: UITextField!
    @IBOutlet weak var purchaseAimTextField: UITextField!
    @IBOutlet weak var purchaseDatePicker: UIDatePicker!
    @IBOutlet weak var errorLabel: UILabel!
    
    var categoryName: String = ""
    weak var delegate: AddPurchaseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        moveIn()
        
        purchaseValueTextField.delegate = self
        purchaseAimTextField.delegate = self
    }
    
    func addPurchase() {
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
    
    @IBAction func addPurchaseBtnTapped(_ sender: Any) {
        
        // Нажатие кнопки добавление расхода, с проверками на корректность данных
        addPurchase()
    }
    
    @IBAction func tapOutsideView (recognizer: UITapGestureRecognizer) {
        let yTap = recognizer.location(in: popUpView).y
        
        if yTap < 0 || yTap > 250 {
            moveOut()
        }
    }
    
}

extension AddPurchaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addPurchase()
        return true
    }
}
