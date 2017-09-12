//
//  DateFormatterTransform.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

class DateFormatterTransform {
    let dateFormatter = make(DateFormatter()) {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    }

    func transformFrom(_ value: String?) -> Date? {
        if let dateString = value {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }

    func transformTo(_ value: Date?) -> String? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
