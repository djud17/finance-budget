//
//  AddRevenuePopUpViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

protocol AddRevenueDelegate {
    func addRevenueToTable(value: Int, type: String)
}

class AddRevenuePopUpViewController: UIViewController {
    
    @IBOutlet weak var sumRevenueTextField: UITextField!
    @IBOutlet weak var typeRevenueTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var delegate: AddRevenueDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        moveIn()
    }
    
    @IBAction func addRevenueBtnTapped(_ sender: Any) {
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
}
