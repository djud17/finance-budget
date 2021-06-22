//
//  Persistance.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import Foundation
import RealmSwift

class Persistance {
    static let shared = Persistance()
    
    let realm = try! Realm()
    
    func realmWrite(_ object: Any) {
        try! realm.write{
            realm.add(object as! Object)
        }
    }
    
    // MARK: Realm read current revenues
    
    func realmDeleteRevenue(_ revenue: Revenue){
        try! realm.write{
            realm.delete(revenue)
        }
    }
    
    func realmReadRevenue() -> Results<Revenue>? {
        let array = realm.objects(Revenue.self)
        return array
    }
    
    // MARK: Realm read current categories

    func realmDeleteCategory(_ category: Category){
        let object = realm.objects(Category.self).filter({$0.categoryName == category.categoryName})
        try! realm.write{
            realm.delete(object)
        }
    }

    func realmReadCategory() -> Results<Category>? {
        let array = realm.objects(Category.self)
        return array
    }
    
    // MARK: Realm read current purchases

    func realmDeletePurchase(_ purchase: Purchase){
        //let object = realm.objects(Purchase.self).filter({$0.purchaseAim == purchase.purchaseAim})
        try! realm.write{
            realm.delete(purchase)
        }
    }

    func realmReadPurchase(_ category: String) -> LazyFilterSequence<Results<Purchase>>? {
        let array = realm.objects(Purchase.self).filter({$0.categoryName == category})
        return array
    }
    
    func realmReadAllPurchase() -> Results<Purchase>? {
        let array = realm.objects(Purchase.self)
        return array
    }
    
    // MARK: UserDefaults read & write current balance
    
    private let curBalanceKey = "Persistance.curBalanceKey"
    
    var balance: Int? {
        set { UserDefaults.standard.set(newValue, forKey: curBalanceKey)}
        get { return UserDefaults.standard.integer(forKey: curBalanceKey)}
    }

}
