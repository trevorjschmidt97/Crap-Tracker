//
//  Extensions.swift
//  Crap Tracker (iOS)
//
//  Created by Trevor Schmidt on 10/18/21.
//

import Foundation

let longStringDateFormat = "yyyy-MM-dd, HH:mm:ss:SSS"
let prettyStringDateFormat = "EEEE, MMM d, yyyy"

extension Date {
    func toLongString() -> String {
        var dateFormatter: DateFormatter {
            let df = DateFormatter()
            df.dateFormat = longStringDateFormat
            return df
        }
        return dateFormatter.string(from: self)
    }
}

extension String {
    func fromLongToShort() -> String {
        var dateFormatter: DateFormatter {
            let df = DateFormatter()
            df.dateFormat = longStringDateFormat
            return df
        }
        let date = dateFormatter.date(from: self)

        var prettyDateFormatter: DateFormatter {
            let df = DateFormatter()
            df.dateFormat = prettyStringDateFormat
            return df
        }
        guard let date = date else {
            return ""
        }

        return prettyDateFormatter.string(from: date)
        
    }
}
