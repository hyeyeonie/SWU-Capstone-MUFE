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
    let artists: [(name: String, image: UIImage?)]
}
