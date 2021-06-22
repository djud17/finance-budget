//
//  PurchasesCategoriesViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

class PurchasesCategoriesViewController: UIViewController {
    
    // Экран Категории расходов

    @IBOutlet weak var categoryTableView: UITableView!
    
    var categoryArray: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Расходы"
        navigationItem.backButtonTitle = "Категории"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Подгрузка данных из памяти
        
        if let categoriesRealmArray = Persistance.shared.realmReadCategory(){
            for el in categoriesRealmArray {
                let category = Category()
                category.categoryName = el.categoryName
                categoryArray.append(category)
            }
            categoryTableView.reloadData()
        }
    }
    
    @IBAction func addCategory(_ sender: Any) {
        
        // Вызов всплывающего окна для добавления категории
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCaddCategory") as! AddCategoryPopUpViewController
        
        popUpVC.delegate = self

        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)

        popUpVC.didMove(toParent: self)
    }
    
}
