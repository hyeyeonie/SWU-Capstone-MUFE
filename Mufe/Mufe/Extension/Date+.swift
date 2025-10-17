//
//  Date+.swift
//  Mufe
//
//  Created by 신혜연 on 9/30/25.
//

import UIKit

extension Date {
    static func fromTimeString(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.date(from: time)
    }
}
