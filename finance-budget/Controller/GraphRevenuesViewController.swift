//
//  GraphRevenuesViewController.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 17.06.2021.
//

import UIKit
import Charts

class GraphRevenuesViewController: UIViewController {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var weekBtn: CustomButton!
    @IBOutlet weak var monthBtn: CustomButton!
    @IBOutlet weak var quarterBtn: CustomButton!
    @IBOutlet weak var allBtn: CustomButton!
    
    var category = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = category.categoryName
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if category.purchases.isEmpty {
            lineChartView.noDataText = "Нет данных"
            lineChartView.noDataFont = UIFont(name: "AvenirNext-DemiBold", size: 15) ?? UIFont.systemFont(ofSize: 15)
        } else {
            let dataSetDict = setData(category.purchases, .all)
            setChart(dataSetDict)
        }
        
        allBtn.backgroundColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        allBtn.tintColor = .white
    }

    // Формирование массива данных
    
    func setData(_ purchases: [Purchase],_ dataType: ChartDataType) -> [(String,String,String,Double)] {
        var chartData: [(String,String,String,Double)] = []
        var purchaseDict: [String:Double] = [:]
        var chartPeriodData: [(String,String,String,Double)] = []
        
        // Создание словаря, ключ - дата покупки, значение - сумма
        // Благодаря этому можем исключить задвоение дат
        
        for el in purchases {
            let arr = el.purchaseDate.components(separatedBy: ".")
            let date = arr[0] + "." + arr[1] + "." + arr[2]
            
            if let val = purchaseDict[date] {
                purchaseDict[date] = val + Double(el.purchaseValue)
            } else {
                purchaseDict[date] = Double(el.purchaseValue)
            }
        }
        
        // Переводим словарь в массив, что позволит нам упорядочить покупки по дате для графиков
        
        for (date,value) in purchaseDict {
            let arr = date.components(separatedBy: ".")
            let day = arr[0]
            let month = arr[1]
            let year = arr[2]
            chartData.append((day,month,year,value))
        }

        chartData.sort(){$0.0 < $1.0}
        chartData.sort(){$0.1 < $1.1}
        chartData.sort(){$0.2 < $1.2}
        
        // Рассчитываем стартовую дату выбранного периода и формируем массив с датами и покупками, которые входят в необходимый период
        
        let last: (Int,Int,Int) = (Int(chartData.last?.0 ?? "") ?? 0,
                                   Int(chartData.last?.1 ?? "") ?? 0,
                                   Int(chartData.last?.2 ?? "") ?? 0)
        
        if let startPeriod: (startDay: Int, startMonth: Int, startYear: Int) = dataPeriodCount(last,dataType) {
            for el in chartData {
                let day = Int(el.0) ?? 0
                let month = Int(el.1) ?? 0
                let year = Int(el.2) ?? 0
                
                if ((month > startPeriod.startMonth) && (year >= startPeriod.startYear)) ||
                    ((month == startPeriod.startMonth) && (day >= startPeriod.startDay) && (year >= startPeriod.startYear)) ||
                    (year > startPeriod.startYear) {
                    chartPeriodData.append(el)
                }
            }
        } else {
            return chartData
        }
        
        return chartPeriodData
    }
    
    // Функция для расчета стартовой даты периода
    
    func dataPeriodCount(_ last: (Int,Int,Int),_ dataType: ChartDataType) -> (Int,Int,Int)? {
        var period = 0
        var ostatok = 0
        
        switch dataType {
        case .week:
            period = 7
        case .month:
            period = 30
        case .quarter:
            period = 91
        case .all:
            return nil
        }
        
        var startPeriod: (Int,Int,Int) = (last.0 - period, last.1, last.2)
        
        while startPeriod.0 <= 0  {
            startPeriod.1 -= 1
            ostatok = -startPeriod.0
            
            if startPeriod.1 <= 0 {
                startPeriod.1 = 12
                startPeriod.2 -= 1
            }
            
            if startPeriod.1 % 2 == 0 {
                startPeriod.0 = 31 - ostatok
            } else {
                startPeriod.0 = 30 - ostatok
            }
            
        }
        return startPeriod
    }
    
    // Формируем график и передаем ему данные
    
    func setChart(_ data: [(String,String,String,Double)]) {
        var dataEntries: [ChartDataEntry] = []
        var xAxisData: [String] = []
        
        // Формируем входные данные в нужном типе
        
        for i in 0..<data.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: data[i].3)
            xAxisData.append(data[i].0 + "." + data[i].1)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "Purchases")
        
        // Конфигурация внешнего вида графика
        
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .cubicBezier
        chartDataSet.lineWidth = 3
        chartDataSet.setColor( #colorLiteral(red: 0.6235294342, green: 0.117264287, blue: 0.06386806873, alpha: 1))
        chartDataSet.fill = Fill(color: #colorLiteral(red: 0.6235294342, green: 0.117264287, blue: 0.06386806873, alpha: 1))
        chartDataSet.fillAlpha = 0.8
        chartDataSet.formSize = 15.0
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawHorizontalHighlightIndicatorEnabled = false
        chartDataSet.highlightColor = .blue
        
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        
        // Конфигурация осей графика
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = UIFont(name: "AvenirNext-DemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        yAxis.setLabelCount(4, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        yAxis.labelPosition = .outsideChart
        
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.labelFont = UIFont(name: "AvenirNext-DemiBold", size: 12) ?? UIFont.systemFont(ofSize: 12)
        lineChartView.xAxis.setLabelCount(6, force: false)
        lineChartView.xAxis.axisLineColor = .black
        
        let xAxisValue = lineChartView.xAxis
        xAxisValue.valueFormatter = IndexAxisValueFormatter(values: xAxisData)
        lineChartView.xAxis.granularity = 1

        
        
        // Отключение "легенды" и добавление анимации графику
        
        lineChartView.legend.enabled = false
        lineChartView.animate(xAxisDuration: 0.3)
        
        // Указываем графику источник данных
        
        lineChartView.data = chartData
        
    }
    
    // Кнопки для задания выбранного периода отображения данных на графике
    
    @IBAction func showWeekGraph(_ sender: Any) {
        let dataSetDict = setData(category.purchases, .week)
        setChart(dataSetDict)
        weekBtn.backgroundColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        weekBtn.tintColor = .white
        
        for btn in [monthBtn,quarterBtn,allBtn] {
            btn?.backgroundColor = .white
            btn?.tintColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        }
    }
    
    @IBAction func showMonthGraph(_ sender: Any) {
        let dataSetDict = setData(category.purchases, .month)
        setChart(dataSetDict)
        monthBtn.backgroundColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        monthBtn.tintColor = .white
        
        for btn in [weekBtn,quarterBtn,allBtn] {
            btn?.backgroundColor = .white
            btn?.tintColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        }
    }
    @IBAction func showQuarterGraph(_ sender: Any) {
        let dataSetDict = setData(category.purchases, .quarter)
        setChart(dataSetDict)
        quarterBtn.backgroundColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        quarterBtn.tintColor = .white
        
        for btn in [weekBtn,monthBtn,allBtn] {
            btn?.backgroundColor = .white
            btn?.tintColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        }
    }
    
    @IBAction func showAllGraph(_ sender: Any) {
        let dataSetDict = setData(category.purchases, .all)
        setChart(dataSetDict)
        allBtn.backgroundColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        allBtn.tintColor = .white
        
        for btn in [weekBtn,monthBtn,quarterBtn] {
            btn?.backgroundColor = .white
            btn?.tintColor = #colorLiteral(red: 0, green: 0.645577633, blue: 0.07150470763, alpha: 1)
        }
    }
}
