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
    var duration: Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        guard let start = formatter.date(from: startTime),
              let end = formatter.date(from: endTime) else { return 0 }
        return Int(end.timeIntervalSince(start) / 60)
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
