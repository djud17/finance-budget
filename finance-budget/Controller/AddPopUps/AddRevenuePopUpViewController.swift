//
//  AddRevenuePopUpViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

protocol AddRevenueDelegate: AnyObject {
    func addRevenueToTable(value: Int, type: String)
}

class AddRevenuePopUpViewController: UIViewController {
    
    // Всплывающий экран для добавления нового дохода
    
    @IBOutlet weak var popUpView: CustomView!
    @IBOutlet weak var sumRevenueTextField: UITextField!
    @IBOutlet weak var typeRevenueTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var delegate: AddRevenueDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        moveIn()
        
        sumRevenueTextField.delegate = self
        typeRevenueTextField.delegate = self
    }
    
    func addRevenue() {
        if let sum = Int(sumRevenueTextField.text!),
           let type = typeRevenueTextField.text,
           sumRevenueTextField.text != "",
           typeRevenueTextField.text != "" {
            errorLabel.isHidden = true
            delegate?.addRevenueToTable(value: sum, type: type)
            moveOut()
        } else {
            errorLabel.isHidden = false
        }
    }
    
    @IBAction func addRevenueBtnTapped(_ sender: Any) {
        
        // Нажатие кнопки добавление дохода, с проверками на корректность данных
        
        addRevenue()
    }
    
    @IBAction func tapOutsideView (recognizer: UITapGestureRecognizer) {
        let yTap = recognizer.location(in: popUpView).y
        
        if yTap < 0 || yTap > 200 {
            moveOut()
        }
    }
}
