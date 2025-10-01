//
//  Utils+.swift
//  Mufe
//
//  Created by 신혜연 on 9/25/25.
//

import Foundation

struct FestivalUtils {
    static func calculateDDay(from startDateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        guard let startDate = formatter.date(from: startDateString) else { return "-" }
        
        let today = Date()
        let calendar = Calendar.current
        let diff = calendar.dateComponents([.day], from: today, to: startDate).day ?? 0
        
        switch diff {
        case let x where x > 0:
            return "D-\(x)"
        default:
            return "D-Day"
        }
    }
}
