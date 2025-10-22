//
//  Festival.swift
//  Mufe
//
//  Created by 신혜연 on 5/28/25.
//

import Foundation
import UIKit

struct Festival {
    let imageName: String
    let name: String
    let startDate: String
    let endDate: String
    let location: String
    let artistSchedule: [String: [ArtistInfo]]
    let days: [FestivalDay]
    
    init(
        imageName: String = "festival_default",
        name: String,
        startDate: String,
        endDate: String,
        location: String,
        artistSchedule: [String: [ArtistInfo]],
        days: [FestivalDay]
    ) {
        self.imageName = imageName
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.artistSchedule = artistSchedule
        self.days = days
    }
}

struct FestivalDay {
    let dayOfWeek: String
    let date: String
}

struct ArtistInfo {
    let stage: String
    let location: String
    let artists: [ArtistSchedule]
}

struct ArtistSchedule {
    let name: String
    let image: String
    let startTime: String
    let endTime: String
    
    init(
        name: String,
        image: String = "artist_default",
        startTime: String,
        endTime: String
    ) {
        self.name = name
        self.image = image
        self.startTime = startTime
        self.endTime = endTime
    }
    
    var duration: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let start = formatter.date(from: startTime),
              let end = formatter.date(from: endTime) else { return 0 }
        return Int(end.timeIntervalSince(start) / 60)
    }
}

enum PerformanceStatus {
    case upcoming   // 아직 시작 전
    case ongoing    // 공연 중
    case finished   // 이미 종료됨
}

extension ArtistSchedule {
    func currentStatus() -> PerformanceStatus {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard let start = formatter.date(from: startTime),
              let end = formatter.date(from: endTime) else {
            return .finished
        }
        
        let now = Date()
        if now < start {
            return .upcoming
        } else if now >= start && now <= end {
            return .ongoing
        } else {
            return .finished
        }
    }
}

extension Festival {
    func toChatContent() -> String {
        var content = "페스티벌 이름: \(name)\n"
        content += "기간: \(startDate) ~ \(endDate)\n"
        content += "장소: \(location)\n"
        content += "아티스트 스케줄:\n"

        for artistInfos in artistSchedule.values.flatMap({ $0 }) {
            content += "- 무대: \(artistInfos.stage), 장소: \(artistInfos.location)\n"
            for artist in artistInfos.artists {
                content += "  * \(artist.name) (\(artist.startTime) ~ \(artist.endTime))\n"
            }
        }
        return content
    }
}
