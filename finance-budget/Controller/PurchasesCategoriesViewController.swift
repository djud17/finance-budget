//
//  PurchasesCategoriesViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit
import SnapKit

final class PurchasesCategoriesViewController: UIViewController {
    
    // MARK: - Elements
    
    private let categoryTableView = UITableView()
    
    // MARK: Parameters
    
    private var categoryArray: [Category] = [] {
        didSet {
            categoryArray.sort { $0.categoryName < $1.categoryName }
        }
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
    }
    
    // MARK: - SetupView functions
    
    private func setupMainView() {
        view.backgroundColor = Constants.whiteColor
        
        setupNavigation()
        
        let titleLabel = createTitleLabel(withText: "Категории:")
        let addCategoryButton = createAddCategoryButton()
        configurateCategoryTableView()
        
        view.addSubview(titleLabel)
        view.addSubview(addCategoryButton)
        view.addSubview(categoryTableView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        addCategoryButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
        
        categoryTableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(addCategoryButton.snp.top).inset(20)
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = "Расходы"
        navigationItem.backButtonTitle = "Категории"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configurateCategoryTableView() {
        categoryTableView.register(UITableViewCell.self,
                                   forCellReuseIdentifier: Constants.purchaseCellReuseID)
        categoryTableView.backgroundColor = Constants.whiteColor
        categoryTableView.allowsSelection = true
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    private func createTitleLabel(withText text: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = Constants.blackColor
        titleLabel.text = text
        return titleLabel
    }
    
    private func createAddCategoryButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
        configurateButtonView(for: button)
        
        return button
    }
    
    private func configurateButtonView(for button: UIButton) {
        let blackColor = Constants.blackColor
        button.setTitleColor(blackColor, for: .normal)
        button.setTitleColor(blackColor.withAlphaComponent(0.5), for: .highlighted)
        
        button.layer.cornerRadius = 15
        button.layer.backgroundColor = Constants.lightGreenColor.cgColor
        button.layer.shadowColor = blackColor.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 5, height: 5)
        button.layer.shadowRadius = 3
    }
    
    @objc private func addCategory(_ sender: UIButton) {
        let addCategoryController = createAlertController()
        present(addCategoryController, animated: true)
    }
    
    private func createAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: nil,
                                                     message: "Добавить категорию",
                                                     preferredStyle: .alert)
        alertController.addTextField()
        alertController.textFields?.last?.placeholder = "Введите категорию"
        let okButton = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            let purchaseCategory = alertController.textFields?.first?.text ?? ""
            
            if !purchaseCategory.isEmpty {
                let category = Category()
                category.categoryName = purchaseCategory
                category.purchases = []
                self?.categoryArray.append(category)
                self?.categoryTableView.reloadData()
            }
        }
        alertController.addAction(okButton)
        
        return alertController
    }
}

// MARK: - Extensions

extension PurchasesCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = categoryArray[indexPath.row]
        let reuseID = Constants.purchaseCellReuseID
        var cell: UITableViewCell
        
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: reuseID) {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: reuseID)
        }
        cell.textLabel?.text = model.categoryName
        
        return cell
    }
}

extension PurchasesCategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            categoryArray[indexPath.row].purchases.removeAll()
            categoryArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryArray[indexPath.row]
        let viewController = PurchaseListViewController(category: category)
        
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
