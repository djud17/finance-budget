//
//  AddCategoryPopUpViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

protocol AddCategoryDelegate {
    func addCategory(categoryName: String)
}

class AddCategoryPopUpViewController: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var delegate: AddCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        moveIn()
    }

    @IBAction func addCategoryBtnTapped(_ sender: Any) {
        if let categoryName = categoryTextField.text,
           categoryTextField.text != "" {
            errorLabel.isHidden = true
            delegate?.addCategory(categoryName: categoryName)
            moveOut()
        } else {
            errorLabel.isHidden = false
        }
    }
}
