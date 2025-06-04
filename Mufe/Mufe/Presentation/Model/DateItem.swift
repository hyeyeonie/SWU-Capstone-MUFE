//
//  DateItem.swift
//  Mufe
//
//  Created by 신혜연 on 6/4/25.
//

import Foundation

struct DateItem {
    let day: String
    let date: String
    let enterTime: String
    let leaveTime: String

    init(day: String, date: String, enterTime: String = "", leaveTime: String = "") {
        self.day = day
        self.date = date
        self.enterTime = enterTime
        self.leaveTime = leaveTime
    }
}
