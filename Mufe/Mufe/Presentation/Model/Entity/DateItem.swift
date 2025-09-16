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
    var isMade: Bool
    let enterTime: String
    let leaveTime: String

    init(day: String, date: String, isMade: Bool, enterTime: String = "", leaveTime: String = "") {
        self.day = day
        self.date = date
        self.isMade = isMade
        self.enterTime = enterTime
        self.leaveTime = leaveTime
    }
}
