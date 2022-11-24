//
//  PurchaseListViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 15.06.2021.
//

import UIKit
import SnapKit

final class PurchaseListViewController: UIViewController {
    
    // MARK: - Elements
    
    private let purchasesListTableView = UITableView()

    // MARK: - Parameters
    
    private var category: Category?
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        
        return formatter
    }()
    
    // MARK: - Inits
    
    init(category: Category) {
        super.init(nibName: nil, bundle: nil)
        
        self.category = category
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        let purchasesGraphButton = createButton(withName: "График платежей")
        purchasesGraphButton.addTarget(self,
                                       action: #selector(purchasesGraphButtonTapped),
                                       for: .touchUpInside)
        setupPurchasesGraphButtonConstraints(purchasesGraphButton)
        
        let addPurchaseButton = createButton(withName: "Добавить расход")
        addPurchaseButton.addTarget(self,
                                    action: #selector(addPurchaseButtonTapped),
                                    for: .touchUpInside)
        setupAddPurchaseButtonConstraints(addPurchaseButton)
        
        let tableTitleStackView = setupTitleLabels()
        configuratePurchasesTableView(with: tableTitleStackView, and: addPurchaseButton)
        setupTableTitleStackViewConstraints(for: tableTitleStackView, under: purchasesGraphButton)
    }
    
    private func setupPurchasesGraphButtonConstraints(_ purchasesGraphButton: UIButton) {
        view.addSubview(purchasesGraphButton)
        
        purchasesGraphButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupAddPurchaseButtonConstraints(_ addPurchaseButton: UIButton) {
        view.addSubview(addPurchaseButton)
        
        addPurchaseButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupTableTitleStackViewConstraints(for stackView: UIStackView, under underView: UIView) {
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(underView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = category?.categoryName
        navigationItem.backButtonTitle = "Категории"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func createButton(withName title: String) -> UIButton {
        let newButton = UIButton()
        newButton.setTitle(title, for: .normal)
        configurateButtonView(for: newButton)
        
        return newButton
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
    
    private func configuratePurchasesTableView(with topView: UIView, and bottomView: UIView) {
        purchasesListTableView.layer.backgroundColor = Constants.whiteColor.cgColor
        purchasesListTableView.dataSource = self
        purchasesListTableView.delegate = self
        purchasesListTableView.allowsSelection = false
        purchasesListTableView.register(PurchaseTableViewCell.self,
                                       forCellReuseIdentifier: Constants.purchaseCellReuseID)
        
        view.addSubview(purchasesListTableView)
        
        purchasesListTableView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(bottomView.snp.top).inset(20)
        }
    }
    
    private func setupTitleLabels() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        for text in ["Название", "Дата", "Сумма"] {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 18)
            label.textColor = Constants.blackColor
            label.text = text
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        
        return stackView
    }
    
    private func separatedNumber(_ number: Any) -> String {
        guard let itIsANumber = number as? NSNumber else { return "Not a number" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        
        return formatter.string(from: itIsANumber) ?? ""
    }

    @objc private func purchasesGraphButtonTapped(sender: UIButton) {
        guard let category else { return }
        
        let graphViewController = GraphRevenuesViewController(category: category)
        navigationController?.pushViewController(graphViewController, animated: true)
    }
    
    @objc private func addPurchaseButtonTapped(sender: UIButton) {
        let addPurchaseController = UIAlertController(title: "Новый расход",
                                                      message: "Добавить расход",
                                                      preferredStyle: .alert)
        let purchaseTitlePlaceholder = "Введите название расхода"
        let purchaseTitleTextField = createTextField(withPlaceholder: purchaseTitlePlaceholder)
        
        let purchaseValuePlaceholder = "Введите сумму"
        let purchaseValueTextField = createTextField(withPlaceholder: purchaseValuePlaceholder)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        let backView = createAlertControllerBackView(with: purchaseTitleTextField,
                                                     purchaseValueTextField,
                                                     datePicker)
        setupAlertControllerBackViewConstraints(for: addPurchaseController,
                                                with: backView)
        
        addPurchaseController.addAction(UIAlertAction(title: "Done",
                                                      style: .default) { [unowned self] _ in
            let purchaseTitle = purchaseTitleTextField.text ?? ""
            let purchaseValue = purchaseValueTextField.text ?? ""
            let checkResult = checkArguments(purchaseTitle, and: purchaseValue)
            
            if checkResult {
                let date = formatter.string(from: datePicker.date).description
                let purchase = createPurchaseObject(purchaseTitle: purchaseTitle,
                                                    purchaseValue: purchaseValue,
                                                    purchaseDate: date)
                category?.purchases.append(purchase)
                purchasesListTableView.reloadData()
            }
        })
        present(addPurchaseController, animated: true)
    }
    
    private func checkArguments(_ purchaseTitle: String, and purchaseValue: String) -> Bool {
        return !purchaseTitle.isEmpty && !purchaseValue.isEmpty && Int(purchaseValue) != nil
    }
    
    private func createPurchaseObject(purchaseTitle: String,
                                      purchaseValue: String,
                                      purchaseDate: String) -> Purchase {
        let purchase = Purchase()
        purchase.purchaseTitle = purchaseTitle
        purchase.purchaseValue = Int(purchaseValue) ?? 0
        purchase.purchaseDate = purchaseDate
        purchase.categoryName = self.category?.categoryName ?? ""
        return purchase
    }
    
    private func createTextField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.backgroundColor = Constants.whiteColor
        
        return textField
    }
    
    private func createAlertControllerBackView(with purchaseTitleTextField: UITextField,
                                               _ purchaseValueTextField: UITextField,
                                               _ datePicker: UIDatePicker) -> UIView {
        let backView = UIView()
        backView.addSubview(purchaseTitleTextField)
        backView.addSubview(purchaseValueTextField)
        backView.addSubview(datePicker)
        
        purchaseTitleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        purchaseValueTextField.snp.makeConstraints { make in
            make.top.equalTo(purchaseTitleTextField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(purchaseValueTextField.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        return backView
    }
    
    private func setupAlertControllerBackViewConstraints(for alertController: UIAlertController,
                                                         with backView: UIView) {
        alertController.view.addSubview(backView)
        
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(150)
        }

        alertController.view.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
    }
}

// MARK: - Extensions

extension PurchaseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category?.purchases.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell") as? PurchaseTableViewCell,
              let category else { return UITableViewCell() }
        let model = category.purchases[indexPath.row]
        configurateCell(cell, withModel: model)
        
        return cell
    }
    
    private func configurateCell(_ cell: PurchaseTableViewCell, withModel model: Purchase) {
        cell.purchaseTitleLabel.text = model.purchaseTitle
        cell.purchaseDateLabel.text = model.purchaseDate
        cell.purchaseValueLabel.text = "- " + separatedNumber(model.purchaseValue) + Constants.currency
        cell.purchaseValueLabel.textColor = Constants.darkRedColor
    }
}

extension PurchaseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            category?.purchases.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
