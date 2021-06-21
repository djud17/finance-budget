//
//  financeModels.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import Foundation
import RealmSwift

class Revenue: Object {
    // Модель данных Доход
    
    @objc dynamic var revenueValue: Int = 0
    @objc dynamic var revenueType: String = ""
}

class Category: Object {
    // Модель данных Категория
    
    @objc dynamic var categoryName: String = ""
    var purchases: [Purchase] = []
}

class Purchase: Object {
    // Модель данных Расход
    
    @objc dynamic var purchaseAim: String = ""
    @objc dynamic var purchaseValue: Int = 0
    @objc dynamic var purchaseDate: String = ""
    @objc dynamic var categoryName: String = ""
}

