//
//  CustomView.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

class CustomView: UIView {
    // Кастомная подложка для отображения баланса
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = 15
        layer.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.09771414976, alpha: 0.1983769903)
    }
}

class CustomButton: UIButton {
    // Кастомный вид кнопки
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBtn()
    }
    
    func setupBtn() {
        layer.borderWidth = 1
        layer.cornerRadius = 15
        clipsToBounds = true
        
        tintColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        layer.borderColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17)
    }
}
