//
//  ViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 31.05.2021.
//

import UIKit
import SnapKit

final class RevenueViewController: UIViewController {
    
    // MARK: - Elements
    
    private let balanceBackView = UIView()
    private let revenueTableView = UITableView()
    private var currentBalanceLabel = UILabel()
    
    // MARK: - Parameters
    
    private let currency = Constants.currency
    private var currentBalance = 0 {
        didSet {
            currentBalanceLabel.text = "\(currentBalance) \(currency)"
            currentBalanceLabel.shake()
        }
    }
    private lazy var revenueArrays: [Revenue] = [] {
        didSet {
            currentBalance += revenueArrays.last?.revenueValue ?? 0
        }
    }
    private enum RevenueError: Error {
        case noData
        case incorrectArguments
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMainView()
        setupInitialValues()
    }
    
    // MARK: - SetupView functions
    
    private func setupMainView() {
        view.backgroundColor = Constants.whiteColor
        
        setupBalanceView()
        setupRevenueBlock()
    }
    
    private func setupInitialValues() {
        currentBalance = 0
        revenueArrays = []
    }
    
    private func setupBalanceView() {
        view.addSubview(balanceBackView)
        
        configurateBalanceBackView()
        setupBalanceBackViewConstraints()
        setupBalanceViewElements()
    }
    
    private func setupBalanceViewElements() {
        let balanceTitleLabel = createLabel(withText: "Текущий баланс:")
        currentBalanceLabel = createLabel(withText: "", andFont: .systemFont(ofSize: 16))
        
        balanceBackView.addSubview(balanceTitleLabel)
        balanceBackView.addSubview(currentBalanceLabel)
        
        setupConstraints(forElement: balanceTitleLabel, under: nil, withOffset: 20)
        setupCurrentBalanceLabelConstraints(under: balanceTitleLabel)
    }
    
    private func configurateBalanceBackView() {
        balanceBackView.layer.shadowColor = Constants.blackColor.cgColor
        balanceBackView.layer.shadowOpacity = 0.2
        balanceBackView.layer.shadowOffset = CGSize(width: 5, height: 5)
        balanceBackView.layer.shadowRadius = 3
        balanceBackView.layer.cornerRadius = 15
        balanceBackView.layer.backgroundColor = Constants.lightGreenColor.cgColor
    }
    
    private func setupRevenueBlock() {
        let revenueTitleLabel = createLabel(withText: "Доходы:")
        let addRevenueButton = createAddRevenueButton()
        configurateRevenueTableView()
        
        view.addSubview(revenueTitleLabel)
        view.addSubview(revenueTableView)
        view.addSubview(addRevenueButton)
        
        setupConstraints(forElement: revenueTitleLabel, under: balanceBackView, withOffset: 20)
        setupAddRevenueButtonConstraints(for: addRevenueButton)
        setupRevenueTableConstraits(under: revenueTitleLabel, bottom: addRevenueButton)
    }
    
    private func configurateRevenueTableView() {
        revenueTableView.backgroundColor = Constants.whiteColor
        revenueTableView.allowsSelection = false
        revenueTableView.delegate = self
        revenueTableView.dataSource = self
    }
    
    private func createAddRevenueButton() -> UIButton {
        let newButton = UIButton()
        newButton.setTitle("Добавить доход", for: .normal)
        newButton.addTarget(self,
                            action: #selector(addRevenue),
                            for: .touchUpInside)
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
    
    private func createLabel(withText text: String, andFont font: UIFont = .boldSystemFont(ofSize: 18)) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = font
        titleLabel.textColor = Constants.blackColor
        titleLabel.text = text
        return titleLabel
    }
    
    private func separatedNumber(_ number: Any) -> String {
        guard let stringNumber = number as? NSNumber else { return "Not a number" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        
        return formatter.string(from: stringNumber) ?? ""
    }
    
    private func createTextField(withPlaceHolder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = placeholder
        textField.backgroundColor = Constants.whiteColor
        
        return textField
    }
    
    private func showErrorMessage(error: RevenueError) {
        var errorMessage: String
        
        switch error {
        case .incorrectArguments:
            errorMessage = "Введены некорректные аргументы"
        case .noData:
            errorMessage = "Данные отсутствуют"
        }
        
        let errorInfoController = UIAlertController(title: "Ошибка",
                                                    message: errorMessage,
                                                    preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        errorInfoController.addAction(okButton)
        
        present(errorInfoController, animated: true)
    }
    
    @objc private func addRevenue(sender: UIButton) {
        let addRevenueController = createAlertController()
        present(addRevenueController, animated: true)
    }
    
    private func createAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: nil,
                                                     message: "Добавить доход",
                                                     preferredStyle: .alert)
        
        let revenueValueTextField = createTextField(withPlaceHolder: "Введите доход")
        let revenueTitleTextField = createTextField(withPlaceHolder: "Введите название дохода")
        
        createBackView(on: alertController.view, with: [revenueValueTextField, revenueTitleTextField])
        
        setupConstraints(forElement: revenueValueTextField, under: nil, withOffset: 10)
        setupConstraints(forElement: revenueTitleTextField, under: revenueValueTextField, withOffset: 10)
        
        alertController.view.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            let revenueValue = revenueValueTextField.text ?? ""
            let revenueTitle = revenueTitleTextField.text ?? ""
            let checkArguments = self?.checkArguments(revenueValue: revenueValue, revenueTitle: revenueTitle) ?? false

            if checkArguments {
                let revenue = Revenue()
                revenue.revenueTitle = revenueTitle
                revenue.revenueValue = Int(revenueValue) ?? 0
                self?.revenueArrays.append(revenue)
                self?.revenueTableView.reloadData()
            } else {
                self?.showErrorMessage(error: .incorrectArguments)
            }
        }
        alertController.addAction(okButton)
        
        return alertController
    }
    
    private func createBackView(on view: UIView, with childViews: [UIView]) {
        let backView = UIView()
        childViews.forEach { backView.addSubview($0) }
        
        view.addSubview(backView)
        
        backView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    private func checkArguments(revenueValue: String, revenueTitle: String) -> Bool {
        return !revenueValue.isEmpty && !revenueTitle.isEmpty && (Int(revenueValue) != nil)
    }
    
    // MARK: - Setup Constraints functions
    
    private func setupConstraints(forElement element: UIView, under underView: UIView?, withOffset value: Int) {
        if let underView {
            element.snp.makeConstraints { make in
                make.top.equalTo(underView.snp.bottom).offset(value)
            }
        } else {
            element.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(value)
            }
        }
        element.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(value)
            make.trailing.equalToSuperview().inset(value)
        }
    }
    
    private func setupCurrentBalanceLabelConstraints(under underView: UIView) {
        currentBalanceLabel.snp.makeConstraints { make in
            make.top.equalTo(underView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupBalanceBackViewConstraints() {
        balanceBackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
    }
    
    private func setupAddRevenueButtonConstraints(for addRevenueButton: UIButton) {
        addRevenueButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    private func setupRevenueTableConstraits(under underView: UIView, bottom bottomView: UIView) {
        revenueTableView.snp.makeConstraints { make in
            make.top.equalTo(underView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(bottomView.snp.top).inset(20)
        }
    }
}

// MARK: - Extensions

extension RevenueViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        revenueArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = revenueArrays[indexPath.row]
        let reuseID = Constants.revenueCellReuseID
        var cell: UITableViewCell
        
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: reuseID) {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: reuseID)
        }
        configurateCell(cell: cell, viewModel: model)
        
        return cell
    }
    
    private func configurateCell(cell: UITableViewCell, viewModel: Revenue) {
        cell.textLabel?.text = viewModel.revenueTitle
        let revenueValue = "+ " + separatedNumber(viewModel.revenueValue) + currency
        cell.detailTextLabel?.text = revenueValue
        cell.detailTextLabel?.textColor = Constants.greenColor
    }
}

extension RevenueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            revenueArrays.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
