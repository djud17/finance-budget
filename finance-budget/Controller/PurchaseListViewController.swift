//
//  PurchaseListViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 15.06.2021.
//

import UIKit
import SnapKit

final class PurchaseListViewController: UIViewController {
    private let purchasesListTableView = UITableView()

    private var category: Category?
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        
        return formatter
    }()
    
    init(category: Category) {
        super.init(nibName: nil, bundle: nil)
        
        self.category = category
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = Constants.whiteColor
        
        navigationItem.title = category?.categoryName
        navigationItem.backButtonTitle = "Категории"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let purchasesGraphButton = setupButton(withName: "График платежей")
        purchasesGraphButton.addTarget(self,
                                       action: #selector(purchasesGraphButtonTapped),
                                       for: .touchUpInside)
        
        let addPurchaseButton = setupButton(withName: "Добавить расход")
        addPurchaseButton.addTarget(self,
                                    action: #selector(addPurchaseButtonTapped),
                                    for: .touchUpInside)
        
        let tableTitleStackView = setupTitleLabels()
        configuratePurchasesTableView()
        
        view.addSubview(purchasesGraphButton)
        view.addSubview(tableTitleStackView)
        view.addSubview(purchasesListTableView)
        view.addSubview(addPurchaseButton)
        
        purchasesGraphButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        tableTitleStackView.snp.makeConstraints { make in
            make.top.equalTo(purchasesGraphButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        addPurchaseButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        purchasesListTableView.snp.makeConstraints { make in
            make.top.equalTo(tableTitleStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(addPurchaseButton.snp.top).inset(20)
        }
        
    }
    
    private func setupButton(withName title: String) -> UIButton {
        let newButton = UIButton()
        newButton.setTitle(title, for: .normal)
        newButton.setTitleColor(Constants.blackColor, for: .normal)
        newButton.setTitleColor(Constants.blackColor.withAlphaComponent(0.5), for: .highlighted)
        
        newButton.layer.cornerRadius = 15
        newButton.layer.backgroundColor = Constants.lightGreenColor.cgColor
        newButton.layer.shadowColor = Constants.blackColor.cgColor
        newButton.layer.shadowOpacity = 0.2
        newButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        newButton.layer.shadowRadius = 3
        
        return newButton
    }
    
    private func configuratePurchasesTableView() {
        purchasesListTableView.layer.backgroundColor = Constants.whiteColor.cgColor
        purchasesListTableView.dataSource = self
        purchasesListTableView.delegate = self
        purchasesListTableView.allowsSelection = false
        purchasesListTableView.register(PurchaseTableViewCell.self,
                                       forCellReuseIdentifier: Constants.purchaseCellReuseID)
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
    
    private func shortDate(longDate: String) -> String {
        var newShortDate = longDate

        let range = longDate.index(longDate.startIndex, offsetBy: 10)..<longDate.endIndex
        newShortDate.removeSubrange(range)
        
        let str = newShortDate.components(separatedBy: "-")
        newShortDate = ""

        for char in str.reversed() {
            newShortDate += char + "."
        }
        
        newShortDate.removeLast()
        
        return newShortDate
    }
    
    private func separatedNumber(_ number: Any) -> String {
        guard let itIsANumber = number as? NSNumber else { return "Not a number" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        
        return formatter.string(from: itIsANumber) ?? ""
    }
    
    private func shortString(fromDate date: Date) -> String {
        formatter.string(from: date)
    }
    
    private func date(fromShortString string: String) -> Date? {
        formatter.date(from: string)
    }

    @objc private func purchasesGraphButtonTapped(sender: UIButton) {
        guard let category else { return }
        
        let graphViewController = GraphRevenuesViewController(category: category)
        navigationController?.pushViewController(graphViewController, animated: true)
    }
    
    @objc private func addPurchaseButtonTapped(sender: UIButton) {
        let addPurchaseController = UIAlertController(title: nil,
                                                      message: "Добавить расход",
                                                      preferredStyle: .alert)
        let purchaseTitleTextField = UITextField()
        purchaseTitleTextField.borderStyle = .roundedRect
        purchaseTitleTextField.placeholder = "Введите название расхода"
        purchaseTitleTextField.backgroundColor = .white
        
        let purchaseValueTextField = UITextField()
        purchaseValueTextField.borderStyle = .roundedRect
        purchaseValueTextField.placeholder = "Введите сумму"
        purchaseValueTextField.backgroundColor = .white
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
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
        
        addPurchaseController.view.addSubview(backView)
        
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(150)
        }

        addPurchaseController.view.snp.makeConstraints { make in
            make.height.equalTo(250)
        }
        
        addPurchaseController.addAction(UIAlertAction(title: "Done",
                                                      style: .default) { [unowned self] _ in
            let purchaseTitle = purchaseTitleTextField.text ?? ""
            let purchaseValue = purchaseValueTextField.text ?? ""
            
            if !purchaseTitle.isEmpty,
               !purchaseValue.isEmpty,
               let purchaseValue = Int(purchaseValue) {
                
                let purchase = Purchase()
                purchase.purchaseTitle = purchaseTitle
                purchase.purchaseValue = purchaseValue
                
                let date = formatter.string(from: datePicker.date)
                
                purchase.purchaseDate = date.description
                purchase.categoryName = self.category?.categoryName ?? ""
                category?.purchases.append(purchase)
                purchasesListTableView.reloadData()
            }
        })
        present(addPurchaseController, animated: true)
    }
}

extension PurchaseListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category?.purchases.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "purchaseCell") as? PurchaseTableViewCell,
              let category else { return UITableViewCell() }
        let model = category.purchases[indexPath.row]
        
        cell.purchaseTitleLabel.text = model.purchaseTitle
        cell.purchaseDateLabel.text = model.purchaseDate
        cell.purchaseValueLabel.text = "- " + separatedNumber(model.purchaseValue) + Constants.currency
        cell.purchaseValueLabel.textColor = Constants.darkRedColor
        
        return cell
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
