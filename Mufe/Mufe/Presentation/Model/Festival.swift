//
//  Festival.swift
//  Mufe
//
//  Created by 신혜연 on 5/28/25.
//

import Foundation
import UIKit

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
    let image: UIImage?
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

