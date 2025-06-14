//
//  TimeTable.swift
//  Mufe
//
//  Created by 신혜연 on 6/10/25.
//

import Foundation
import UIKit

struct Timetable: Codable {
    let artistName: String
    let imageName: String
    let location: String
    let startTime: String
    let endTime: String
    let runningTime: Int
    let script: String
}

struct TimetableWrapper: Codable {
    let TimetableData: [Timetable]
}
