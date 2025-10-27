//
//  Utils+.swift
//  Mufe
//
//  Created by 신혜연 on 9/25/25.
//

import Foundation

struct FestivalUtils {
    static func calculateDDay(from startDateString: String) -> String {
        let dayDifference = calculateDayDifference(from: startDateString)
        
        if dayDifference == 0 {
            return "D-DAY"
        } else if dayDifference > 0 {
            return "D-\(dayDifference)"
        } else {
            return "D+\(-dayDifference)"
        }
    }
    
    static func getDaysRemainingString(from startDateString: String) -> String {
        let dayDifference = calculateDayDifference(from: startDateString)
        return "\(dayDifference)일"
    }
    
    private static func calculateDayDifference(from dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let startDate = formatter.date(from: dateString) else {
            return 0
        }
        
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfStartDate = calendar.startOfDay(for: startDate)
        
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfStartDate)
        
        return components.day ?? 0
    }
    
    static func getCurrentDayString(from startDateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let startDate = formatter.date(from: startDateString) else {
            return "1일차"
        }
        
        let today = Date()
        
        let startDay = Calendar.current.startOfDay(for: startDate)
        let todayDay = Calendar.current.startOfDay(for: today)
        
        let components = Calendar.current.dateComponents([.day], from: startDay, to: todayDay)
        let dayDifference = (components.day ?? 0) + 1
        
        return "\(dayDifference)일차"
    }
}
