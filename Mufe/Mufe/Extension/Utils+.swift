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
            return "D+\(-dayDifference)" // 이미 지난 경우
        }
    }
    
    // 👇 2. "XX일" 포맷을 반환하는 새로운 함수 추가
    static func getDaysRemainingString(from startDateString: String) -> String {
        let dayDifference = calculateDayDifference(from: startDateString)
        return "\(dayDifference)일"
    }
    
    // 👇 3. 날짜 차이를 정확하게 계산하는 핵심 로직 (private으로 변경)
    private static func calculateDayDifference(from dateString: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 시간대 고정
        
        guard let startDate = formatter.date(from: dateString) else {
            return 0
        }
        
        let calendar = Calendar.current
        
        // 시간, 분, 초를 무시하고 '날짜'만 비교하기 위해 각 날짜의 자정(00:00)을 기준으로 잡습니다.
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
            return "1일차" // 기본값
        }
        
        let today = Date()
        
        let startDay = Calendar.current.startOfDay(for: startDate)
        let todayDay = Calendar.current.startOfDay(for: today)
        
        let components = Calendar.current.dateComponents([.day], from: startDay, to: todayDay)
        let dayDifference = (components.day ?? 0) + 1
        
        return "\(dayDifference)일차"
    }
}
