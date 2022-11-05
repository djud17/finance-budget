//
//  Persistance.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import RealmSwift

enum RealmError: Error {
    case writeError
    case deleteError
    case readError
}

final class Storage {
    static let shared = Storage()
    
    // MARK: UserDefaults read & write current balance
    
    private let curBalanceKey = "Persistance.curBalanceKey"
    var balance: Int? {
        get { UserDefaults.standard.integer(forKey: curBalanceKey) }
        set { UserDefaults.standard.set(newValue, forKey: curBalanceKey) }
    }
    private let realm = try? Realm()
    
    func realmWrite(writedObject: Object) throws {
        guard let realm else { return }
        
        do {
            try realm.write { realm.add(writedObject) }
        } catch {
            throw RealmError.writeError
        }
    }
    
    // MARK: Realm read current revenues
    
    func realmDeleteRevenue(deletedObject: Revenue) throws {
        guard let realm else { return }
        
        do {
            try realm.write { realm.delete(deletedObject) }
        } catch {
            throw RealmError.writeError
        }
    }
    
    func realmReadRevenue() -> Results<Revenue>? {
        guard let realm else { return nil }
        
        return realm.objects(Revenue.self)
    }
    
    // MARK: Realm read current categories
    
    func realmDeleteCategory(deletedCategory: Category) throws {
        guard let realm else { return }
        
        let deletedArray = realm.objects(Category.self).filter {
            $0.categoryName == deletedCategory.categoryName
        }
        
        do {
            try realm.write { realm.delete(deletedArray) }
        } catch {
            throw RealmError.deleteError
        }
    }
    
    func realmReadCategory() -> Results<Category>? {
        guard let realm else { return nil }
        
        return realm.objects(Category.self)
    }
    
    // MARK: Realm read current purchases
    
    func realmDeletePurchase(deletedPurchase: Purchase) throws {
        guard let realm else { return }
        
        do {
            try realm.write { realm.delete(deletedPurchase) }
        } catch {
            throw RealmError.deleteError
        }
    }
    
    func realmReadPurchase(purchaseCategory: String) -> LazyFilterSequence<Results<Purchase>>? {
        guard let realm else { return nil }
        
        let categoryArray = realm.objects(Purchase.self).filter {
            $0.categoryName == purchaseCategory
        }
        return categoryArray
    }
    
    func realmReadAllPurchase() -> Results<Purchase>? {
        guard let realm else { return nil }
        
        return realm.objects(Purchase.self)
    }
}
