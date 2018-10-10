//
//  DateUtils.swift
//  App
//
//  Created by Gabriel Leandro Mazzei on 17/9/18.
//

import Foundation

class DateUtils {
    static let YearMonthDay = "yyyy-MM-dd"
    
    static func getFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = YearMonthDay
        return dateFormatter
    }
}
