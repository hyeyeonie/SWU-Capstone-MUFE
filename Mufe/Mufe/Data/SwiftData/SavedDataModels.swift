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

extension SavedFestival {
    func toFestivalModel() -> Festival {
        // timetables를 stage 이름으로 그룹핑합니다. -> ["Main Stage": [공연1, 공연2], "Sub Stage": [공연3]]
        let groupedByStage = Dictionary(grouping: timetables) { $0.stage }
        
        // 그룹핑된 데이터를 [ArtistInfo] 형태로 변환합니다.
        let artistInfos = groupedByStage.map { (stageName, timetablesForStage) -> ArtistInfo in
            let artistSchedules = timetablesForStage.map {
                ArtistSchedule(
                    name: $0.artistName,
                    image: $0.artistImage,
                    startTime: $0.startTime,
                    endTime: $0.endTime
                )
            }
            
            return ArtistInfo(
                stage: stageName,
                location: timetablesForStage.first?.location ?? "",
                artists: artistSchedules.sorted { $0.startTime < $1.startTime }
            )
        }
        
        // Festival 객체가 요구하는 [String: [ArtistInfo]] 형태로 최종 변환합니다.
        // 여기서는 저장된 날짜(selectedDay) 하나에 대한 정보만 존재합니다.
        let artistScheduleDict: [String: [ArtistInfo]] = [
            self.selectedDay: artistInfos.sorted { $0.stage < $1.stage }
        ]
        
        // FestivalDay 객체를 생성합니다.
        let days = [FestivalDay(dayOfWeek: "", date: self.selectedDate)]
        
        return Festival(
            imageName: festivalImageName,
            name: festivalName,
            startDate: startDate,
            endDate: endDate,
            location: location,
            artistSchedule: artistScheduleDict,
            days: days
        )
    }
}
