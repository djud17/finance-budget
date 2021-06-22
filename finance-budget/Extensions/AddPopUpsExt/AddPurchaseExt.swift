//
//  addPurchasesExt.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 22.06.2021.
//

import UIKit

extension AddPurchaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addPurchase()
        return true
    }
}
