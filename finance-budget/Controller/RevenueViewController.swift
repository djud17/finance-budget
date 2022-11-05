//
//  ViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 31.05.2021.
//

import UIKit
import SnapKit

final class RevenueViewController: UIViewController {
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var revenueTableView: UITableView!
    
    private var currentBalance = 0
    private var revenueArrays: [Revenue] = []
    private var currency = " \u{20BD}"
    
    private let storage = Storage.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let newBalance = storage.balance {
            currentBalance = newBalance
            balanceLabel.text = separatedNumber(newBalance) + currency
        }
    }
    
    private func setupView() {
        revenueTableView.tableFooterView = UIView()
        revenueTableView.allowsSelection = false
        
        // Подгрузка данных из памяти
        
        if let revenueRealmArray = storage.realmReadRevenue(),
           let newBalance = storage.balance {
            for el in revenueRealmArray {
                revenueArrays.append(el)
            }
            revenueTableView.reloadData()
            currentBalance = newBalance
            balanceLabel.text = separatedNumber(newBalance) + currency
        }
    }
    
    @IBAction func addRevenue(_ sender: Any) {
        
        // Вызов всплывающего окна для добавления дохода
        
        let popUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpVCaddRevenue") as! AddRevenuePopUpViewController
        popUpVC.delegate = self

        self.addChild(popUpVC)
        popUpVC.view.frame = self.view.frame
        self.view.addSubview(popUpVC.view)

        popUpVC.didMove(toParent: self)
    }
}

extension RevenueViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Задаем количество ячеек
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if revenueArrays.count == 0 {
            tableView.setEmptyMessage("Нет записей о доходах")
        } else {
            tableView.restore()
        }

        return revenueArrays.count
    }
    
    // Формируем ячейку и передаем данные в элементы ячейки
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "revenueCell")
        let model = revenueArrays[indexPath.row]
        
        cell?.textLabel?.text = model.revenueType
        cell?.detailTextLabel?.text = "+ " + separatedNumber(model.revenueValue) + currency
        cell?.detailTextLabel?.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        return cell!
    }
    
    // Добавляем возможность удаления ячейки и соответствующих данных
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let revenue = self.revenueArrays[indexPath.row]
            
            self.revenueArrays.remove(at: indexPath.row)
            self.currentBalance -= revenue.revenueValue
            
            Persistance.shared.balance = self.currentBalance
            Persistance.shared.realmDeleteRevenue(revenue)
            
            self.balanceLabel.text = self.separatedNumber(self.currentBalance) + currency
            self.balanceLabel.shake()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

extension RevenueViewController: AddRevenueDelegate {
    
    // Передаем данные с помощью делегата и добавляем в массив, формирующий таблицу
    // Запись дохода в Realm
    
    func addRevenueToTable(value: Int, type: String) {
        let revenue = Revenue()
        revenue.revenueValue = value
        revenue.revenueType = type
        
        currentBalance += value
        Persistance.shared.balance = currentBalance
        
        revenueArrays.append(revenue)
        Persistance.shared.realmWrite(revenue)
        
        balanceLabel.text = separatedNumber(currentBalance) + currency
        balanceLabel.shake()
        revenueTableView.reloadData()
    }
}

extension UIViewController {
    
    // Функция анимирования появления всплывающего окна
    
    func moveIn() {
        self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
        self.view.alpha = 0.0
        
        UIView.animate(withDuration: 0.24) {
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.view.alpha = 1.0
        }
    }
    
    // Функция анимирования исчезания всплывающего окна

    func moveOut() {
        UIView.animate(withDuration: 0.24, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
            self.view.alpha = 0.0
        }) { _ in
            self.view.removeFromSuperview()
        }
    }
    
    // Функция для отображения числа с разделением на десятки
    
    func separatedNumber(_ number: Any) -> String {
        guard let itIsANumber = number as? NSNumber else { return "Not a number" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        return formatter.string(from: itIsANumber)!
    }
    
    // Функция сокращения даты
    
    func shortDate(_ longDate: String) -> String {
        var newShortDate = longDate
        
        let range = longDate.index(longDate.startIndex, offsetBy: 10)..<longDate.endIndex
        newShortDate.removeSubrange(range)
        
        let str = newShortDate.components(separatedBy: "-")
        newShortDate = ""

        for el in str.reversed() {
            newShortDate += el + "."
        }
        
        newShortDate.removeLast()
        
        return newShortDate
    }
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        // make sure the following are the same as that used in the API
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale.current
        
        return formatter
    }()
    
    class func shortString(fromDate date: Date) -> String {
        return formatter.string(from: date)
    }
    
    class func date(fromShortString string: String) -> Date? {
        return formatter.date(from: string)
    }
}

extension UITableView {
    
    // Добавления сообщения, когда нет информации

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

extension UILabel {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
