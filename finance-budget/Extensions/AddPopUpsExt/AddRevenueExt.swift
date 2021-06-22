//
//  AddRevenueExte.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 22.06.2021.
//

import UIKit

extension AddRevenuePopUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addRevenue()
        return true
    }
}
