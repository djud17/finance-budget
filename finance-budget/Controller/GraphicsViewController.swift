//
//  GraphicsViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 16.06.2021.
//

import UIKit
import Charts

class GraphicsViewController: UIViewController {
    
    // Экран График расходы и доходы
    
    @IBOutlet weak var allRevenuesLabel: UILabel!
    @IBOutlet weak var allPurchasesLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Подгрузка данных из памяти
        
        if let revenueRealmArray = Persistance.shared.realmReadRevenue(),
           let purchaseRealmArray = Persistance.shared.realmReadAllPurchase() {
            var revenueSum = 0
            var purchaseSum = 0
            
            for el in revenueRealmArray {
                revenueSum += el.revenueValue
            }
            for el in purchaseRealmArray {
                purchaseSum += el.purchaseValue
            }
            allRevenuesLabel.text = "+ " + separatedNumber(revenueSum) + " \u{20BD}"
            allRevenuesLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            
            allPurchasesLabel.text = "- " + separatedNumber(purchaseSum) + " \u{20BD}"
            allPurchasesLabel.textColor = #colorLiteral(red: 0.6235294342, green: 0.117264287, blue: 0.06386806873, alpha: 1)
            
            customizeChart(dataPoints: ["Доходы","Расходы"], values: [revenueSum,purchaseSum].map{ Double($0) })
        }
    }

    func customizeChart(dataPoints: [String], values: [Double]) {
        
        // Формирование графика
        
        // Установка массива входных значений
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        // Установка сегментов
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
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
