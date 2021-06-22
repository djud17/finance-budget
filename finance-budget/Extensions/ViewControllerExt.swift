//
//  ViewControllerExt.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 14.06.2021.
//

import UIKit

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
