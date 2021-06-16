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
    
    // Всплывающий экран для добавления новой категории

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var delegate: AddCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        moveIn()
    }

    @IBAction func addCategoryBtnTapped(_ sender: Any) {
        
        // Нажатие кнопки добавление категории, с проверками на корректность данных
        
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
