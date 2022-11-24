//
//  GraphicsViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 16.06.2021.
//

import UIKit
import SnapKit

final class GraphicsViewController: UIViewController {
    
    // MARK: - Elements
    
    private let allRevenuesLabel = UILabel()
    private let allPurchasesLabel = UILabel()
    
    // @IBOutlet weak var chartView: PieChartView!
    
    // MARK: - Parameters
    
    private var revenueSum = 0
    private var purchaseSum = 0
    private let currency = Constants.currency
    
    //let storage = Storage.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        //allRevenuesLabel.text = "+ " + separatedNumber(revenueSum) + currency
        allRevenuesLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        //allPurchasesLabel.text = "- " + separatedNumber(purchaseSum) + currency
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Подгрузка данных из памяти
        
//        if let revenueRealmArray = storage.realmReadRevenue(),
//           let purchaseRealmArray = storage.realmReadAllPurchase() {
//            
//            if revenueRealmArray.isEmpty && purchaseRealmArray.isEmpty {
//                showNoData()
//            } else {
//                revenueSum = 0
//                purchaseSum = 0
//                
//                for el in revenueRealmArray {
//                    revenueSum += el.revenueValue
//                }
//                for el in purchaseRealmArray {
//                    purchaseSum += el.purchaseValue
//                }
//                
//                showData()
//            }
//        }
    }
    
    //    private func shortDate(longDate: String) -> String {
    //        var newShortDate = longDate
    //
    //        let range = longDate.index(longDate.startIndex, offsetBy: 10)..<longDate.endIndex
    //        newShortDate.removeSubrange(range)
    //
    //        let str = newShortDate.components(separatedBy: "-")
    //        newShortDate = ""
    //
    //        for char in str.reversed() {
    //            newShortDate += char + "."
    //        }
    //
    //        newShortDate.removeLast()
    //
    //        return newShortDate
    //    }
    
//   private func shortString(fromDate date: Date) -> String {
//        formatter.string(from: date)
//    }
//
//    private func date(fromShortString string: String) -> Date? {
//        formatter.date(from: string)
//    }
    
    func showNoData() {
        chartView.noDataText = "Нет данных"
        chartView.noDataFont = UIFont(name: "AvenirNext-DemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15)
    }
    
    func showData() {
        //allRevenuesLabel.text = "+ " + separatedNumber(revenueSum) + currency
        allRevenuesLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        
        //allPurchasesLabel.text = "- " + separatedNumber(purchaseSum) + currency
        allPurchasesLabel.textColor = #colorLiteral(red: 0.6235294342, green: 0.117264287, blue: 0.06386806873, alpha: 1)
        
        
        setChart(dataPoints: ["Доходы","Расходы"], values: [revenueSum,purchaseSum].map{ Double($0) })
    }

    func setChart(dataPoints: [String], values: [Double]) {
        
        // Формирование графика
        
        // Установка массива входных значений
        var dataEntries: [ChartDataEntry] = []
        for index in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[index], label: dataPoints[index], data: dataPoints[index] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // Установка сегментов
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
        pieChartDataSet.colors = [#colorLiteral(red: 0.1274035899, green: 0.6980392157, blue: 0.03852839612, alpha: 1), #colorLiteral(red: 0.6231456399, green: 0.1557593048, blue: 0.1239754036, alpha: 1)]
        
        // Установка формата графика
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        // Установка источника данных для графика
        
        chartView.data = pieChartData
    }
}
