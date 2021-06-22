//
//  AddCategoryPopUpViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

protocol AddCategoryDelegate: AnyObject {
    func addCategory(categoryName: String)
}

class AddCategoryPopUpViewController: UIViewController {
    
    // Всплывающий экран для добавления новой категории

    @IBOutlet weak var popUpView: CustomView!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    weak var delegate: AddCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        moveIn()
        
        categoryTextField.delegate = self
    }
    
    func addCategory() {
        if let categoryName = categoryTextField.text,
           categoryTextField.text != "" {
            errorLabel.isHidden = true
            delegate?.addCategory(categoryName: categoryName)
            moveOut()
        } else {
            errorLabel.isHidden = false
        }
    }

    @IBAction func addCategoryBtnTapped(_ sender: Any) {
        // Нажатие кнопки добавление категории, с проверками на корректность данных
        addCategory()
    }
    
    @IBAction func tapOutsideView (recognizer: UITapGestureRecognizer) {
        let yTap = recognizer.location(in: popUpView).y
        
        if yTap < 0 || yTap > 200 {
            moveOut()
        }
    }
}
