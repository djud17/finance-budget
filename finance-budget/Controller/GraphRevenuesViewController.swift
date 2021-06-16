//
//  GraphRevenuesViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 17.06.2021.
//

import UIKit
import Charts

class GraphRevenuesViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView!
    
    var category = Category()
    var purchaseValueArray: [Int] = []
    var purchaseDateArray: [(Int,Int,Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category.categoryName
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        for el in category.purchases {
            let arr = el.purchaseDate.components(separatedBy: ".")
            purchaseDateArray.append((Int(arr[0]) ?? 0,Int(arr[1]) ?? 0,Int(arr[2]) ?? 0))
            purchaseValueArray.append(el.purchaseValue)
        }
        
        purchaseDateArray.sort(by: { $0 < $1})

        setChart(dataPoints: purchaseDateArray.map({$0.0}), values: purchaseValueArray.map { Double($0) })
    }
    
    func setChart(dataPoints: [Int], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(dataPoints[i]), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Bar Chart View")
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }

}
