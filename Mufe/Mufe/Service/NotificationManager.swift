//
//  NotificationManager.swift
//  Mufe
//
//  Created by 신혜연 on 11/18/25.
//

import UIKit
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    private let center = UNUserNotificationCenter.current()
    
    private init() {
        center.delegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate
    }
    
    // MARK: - 1. 권한 요청
    
    func requestNotificationPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("🚨 알림 권한 요청 실패: \(error)")
            }
            if granted {
                print("✅ 알림 권한 허용됨")
            } else {
                print("❌ 알림 권한 거부됨")
            }
        }
    }
    
    // MARK: - 2. 알림 예약
    
    /// [최종] 공연 30분 전 알림 예약
    func schedulePerformanceReminder(timetable: SavedTimetable, festival: SavedFestival) {
        
        // 1. 공연 시작 시간(Date) 계산
        guard let performanceStartDate = getPerformanceStartDate(timetable: timetable, festival: festival) else {
            print("🚨 알림 시간 계산 실패 (공연 시작 시간): \(timetable.artistName)")
            return
        }
        
        // 2. 알림 시간 (공연 30분 전) 계산
        guard let notificationDate = Calendar.current.date(byAdding: .minute, value: -30, to: performanceStartDate) else {
            print("🚨 알림 시간 계산 실패 (30분 전): \(timetable.artistName)")
            return
        }
        
        // 3. 현재 시간보다 과거면 예약하지 않음
        if notificationDate < Date() {
            print("ℹ️ 알림 시간이 이미 지났습니다: \(timetable.artistName)")
            return
        }
        
        // --- 알림 콘텐츠 설정 ---
        let content = UNMutableNotificationContent()
        content.title = "\(timetable.artistName) 공연 30분 전"
        content.body = "\(timetable.location)에서 곧 공연이 시작돼요."
        content.sound = .default
        
        // --- 트리거 설정 ---
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let identifier = "performance-\(festival.festivalName)-\(timetable.artistName)-\(timetable.startTime)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("🚨 공연 알림 예약 실패: \(error.localizedDescription)")
            } else {
                print("✅ [\(identifier)] 30분 전 알림 예약 성공 (\(triggerDateComponents))")
            }
        }
    }
    
    func schedulePostFestivalReminder(festival: SavedFestival) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let endDate = formatter.date(from: festival.endDate) else {
            print("🚨 페스티벌 종료 날짜 변환 실패: \(festival.endDate)")
            return
        }
        
        // 종료일 + 1일 (다음 날)
        guard let dayAfter = Calendar.current.date(byAdding: .day, value: 1, to: endDate) else { return }
        
        guard let notificationDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: dayAfter) else { return }
        
        if notificationDate < Date() {
            print("ℹ️ 후기 알림 시간이 이미 지났습니다.")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "오늘의 페스티벌은 즐거웠나요?"
        content.body = "페스티벌에서 즐긴 추억을 남겨보세요."
        content.sound = .default
        
        let triggerDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        
        let identifier = "post-festival-\(festival.festivalName)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("🚨 후기 알림 예약 실패: \(error.localizedDescription)")
            } else {
                print("✅ [\(identifier)] 후기 알림 예약 성공 (시간: \(triggerDateComponents))")
            }
        }
    }
    
    // MARK: - 3. 알림 취소
    
    func cancelPerformanceReminders(for savedDay: SavedFestival) {
        let identifiersToRemove = savedDay.timetables.map { timetable in
            "performance-\(savedDay.festivalName)-\(timetable.artistName)-\(timetable.startTime)"
        }
        if !identifiersToRemove.isEmpty {
            center.removePendingNotificationRequests(withIdentifiers: identifiersToRemove)
        }
    }
    
    func cancelPostFestivalReminder(for festival: SavedFestival) {
        let identifier = "post-festival-\(festival.festivalName)"
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    // MARK: - Private Helper
    
    private func getPerformanceStartDate(timetable: SavedTimetable, festival: SavedFestival) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let festivalStartDate = formatter.date(from: festival.startDate) else { return nil }
        guard let dayOffsetString = festival.selectedDay.components(separatedBy: CharacterSet.decimalDigits.inverted).first,
              let dayOffset = Int(dayOffsetString) else { return nil }
        guard let performanceDayStart = Calendar.current.date(byAdding: .day, value: dayOffset - 1, to: festivalStartDate) else { return nil }

        let timeComponents = timetable.startTime.split(separator: ":")
        guard timeComponents.count == 2,
              let hour = Int(timeComponents[0]),
              let minute = Int(timeComponents[1]) else {
            if timetable.startTime.count == 4,
               let hour = Int(timetable.startTime.prefix(2)),
               let minute = Int(timetable.startTime.suffix(2)) {
                let components = DateComponents(hour: hour, minute: minute)
                return Calendar.current.date(byAdding: components, to: performanceDayStart)
            }
            return nil
        }
        
        let components = DateComponents(hour: hour, minute: minute)
        return Calendar.current.date(byAdding: components, to: performanceDayStart)
    }
}
