//
//  SavedDataModels.swift
//  Mufe
//
//  Created by 신혜연 on 10/15/25.
//

import Foundation
import SwiftData

@Model
final class SavedFestival {
    // 중복 방지를 위한 고유 id
    @Attribute(.unique) var id: String

    var festivalName: String
    var festivalImageName: String
    var startDate: String
    var endDate: String
    var location: String
    var selectedDay: String
    var selectedDate: String

    // 페스티벌이 삭제되면, 속한 타임테이블도 함께 삭제
    @Relationship(deleteRule: .cascade, inverse: \SavedTimetable.savedFestival)
    var timetables: [SavedTimetable] = []

    init(festival: Festival, selectedDateItem: DateItem, timetables: [SavedTimetable]) {
        self.id = "\(festival.name)_\(selectedDateItem.day)"
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
    
    @Relationship(deleteRule: .cascade)
    var memory: ArtistMemory?
    var savedFestival: SavedFestival?
    
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

// 아티스트별 추억 정보
@Model
final class ArtistMemory {
    @Attribute(.unique) var id: String
    var reviewText: String = ""
    var photoIdentifiers: [String] = []

    @Relationship(inverse: \SavedTimetable.memory)
    var savedTimetable: SavedTimetable?

    init(savedTimetable: SavedTimetable, reviewText: String = "", photoIdentifiers: [String] = []) {
        self.id = "\(savedTimetable.savedFestival?.id ?? "unknown")_\(savedTimetable.artistName)"
        self.reviewText = reviewText
        self.photoIdentifiers = Array(photoIdentifiers.prefix(5))
        self.savedTimetable = savedTimetable
    }
}
