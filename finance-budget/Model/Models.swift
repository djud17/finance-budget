//
//  financeModels.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import RealmSwift

final class Revenue: Object {
    @objc dynamic var revenueValue: Int = 0
    @objc dynamic var revenueTitle: String = ""
}

final class Category: Object {
    @objc dynamic var categoryName: String = ""
    var purchases: [Purchase] = []
}

final class Purchase: Object {
    @objc dynamic var purchaseTitle: String = ""
    @objc dynamic var purchaseValue: Int = 0
    @objc dynamic var purchaseDate: String = ""
    @objc dynamic var categoryName: String = ""
}

enum ChartDataType {
    case week
    case month
    case quarter
    case all
}
