//
//  financeModels.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import Foundation
import RealmSwift

class Revenue: Object {
    @objc dynamic var revenueValue: Int = 0
    @objc dynamic var revenueType: String = ""
}

class Category: Object {
    @objc dynamic var categoryName: String = ""
    var purchases: [Purchase] = []
}

class Purchase: Object {
    @objc dynamic var purchaseAim: String = ""
    @objc dynamic var purchaseValue: Int = 0
    @objc dynamic var purchaseDate: String = ""
    @objc dynamic var categoryName: String = ""
}

