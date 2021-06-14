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
    
    // MARK: Realm read & write current revenues
    
    func realmWrite(_ revenue: Revenue){
        try! realm.write{
            realm.add(revenue)
        }
    }
    
    func realmDelete(_ revenue: Revenue){
        try! realm.write{
            realm.delete(revenue)
        }
    }
    
    func realmRead() -> Results<Revenue>? {
        let array = realm.objects(Revenue.self)
        
        return array
    }
    
    // MARK: UserDefaults read & write current balance
    
    private let curBalanceKey = "Persistance.curBalanceKey"
    
    var balance: Int? {
        set { UserDefaults.standard.set(newValue, forKey: curBalanceKey)}
        get { return UserDefaults.standard.integer(forKey: curBalanceKey)}
    }

}
