//
//  Color+.swift
//  Mufe
//
//  Created by 최하늘 on 5/27/25.
//

import SwiftUI

extension Color {
    // 그라데이션 컬러
    static var btmBar: LinearGradient {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.11).opacity(0), location: 0.00),
                Gradient.Stop(color: Color(red: 0.08, green: 0.08, blue: 0.11), location: 0.20),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
}
