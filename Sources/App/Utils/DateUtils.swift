//
//  DateUtils.swift
//  App
//
//  Created by Gabriel Leandro Mazzei on 17/9/18.
//

import Foundation

class DateUtils {
    static let Iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    
    static func getIso8601Formatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Iso8601
        return dateFormatter
    }
}
