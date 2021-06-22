//
//  AddCategoryExt.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 22.06.2021.
//

import UIKit

extension  AddCategoryPopUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addCategory()
        return true
    }
}
