//
//  SavedDataModels.swift
//  Mufe
//
//  Created by 신혜연 on 10/15/25.
//

import Foundation
import SwiftData

// 최종적으로 저장될 페스티벌 시간표 정보
@Model
final class SavedFestival {
    // ⭐️ 고유 ID: 같은 페스티벌의 같은 날짜는 덮어쓰도록 설정합니다.
    @Attribute(.unique) var id: String

    var festivalName: String
    var festivalImageName: String
    var startDate: String
    var endDate: String
    var location: String
    var selectedDay: String
    var selectedDate: String

    // ⭐️ 이 페스티벌에 속한 타임테이블 목록 (1:N 관계)
    // 페스티벌이 삭제되면, 속한 타임테이블도 함께 삭제됩니다.
    @Relationship(deleteRule: .cascade)
    var timetables: [SavedTimetable] = []

    init(festival: Festival, selectedDateItem: DateItem, timetables: [SavedTimetable]) {
        self.id = "\(festival.name)_\(selectedDateItem.day)" // 예: "뷰티풀민트라이프_1일차"
        self.festivalName = festival.name
        self.festivalImageName = festival.imageName
        self.startDate = festival.startDate
        self.endDate = festival.endDate
        self.location = festival.location
        self.selectedDay = selectedDateItem.day
        self.selectedDate = selectedDateItem.date
        self.timetables = timetables
    }
}

// 저장될 개별 공연 정보
@Model
final class SavedTimetable {
    var artistName: String
    var artistImage: String
    var stage: String
    var location: String
    var startTime: String
    var endTime: String
    var runningTime: Int

    // ⭐️ AI가 준 Timetable과 원본 Festival 데이터를 조합해서 생성합니다.
    init(from timetable: Timetable, artistImage: String, stage: String) {
        self.artistName = timetable.artistName
        self.artistImage = artistImage
        self.stage = stage
        self.location = timetable.location
        self.startTime = timetable.startTime
        self.endTime = timetable.endTime
        self.runningTime = timetable.runningTime
    }
}
