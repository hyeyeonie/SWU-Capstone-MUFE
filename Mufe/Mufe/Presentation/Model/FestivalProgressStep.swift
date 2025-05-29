//
//  FestivalProgressStep.swift
//  Mufe
//
//  Created by 신혜연 on 5/27/25.
//

import UIKit

enum FestivalProgressStep: Int {
    case festivalSelection = 0
    case dateSelection
    case timeSelection
    case artistSelection
    
    var progress: CGFloat {
        switch self {
        case .festivalSelection:
            return 0.25
        case .dateSelection:
            return 0.5
        case .timeSelection:
            return 0.75
        case .artistSelection:
            return 1.0
        }
    }
    
    func attributedTitle(with festivalName: String) -> NSAttributedString {
        let fullText: String
        switch self {
        case .festivalSelection:
            fullText = "어떤 페스티벌에\n참여하실 예정인가요?"
            return NSAttributedString(
                string: fullText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                    .foregroundColor: UIColor.white
                ]
            )
            
        case .dateSelection:
            fullText = "\(festivalName)에\n언제 방문하실 예정인가요?"
            
        case .timeSelection:
            fullText = "\(festivalName)에\n얼마나 머무르시나요?"
            
        case .artistSelection:
            fullText = "\(festivalName)에\n꼭 보고 싶은 무대가 있나요?"
        }
        
        let attributed = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 24, weight: .regular),
                .foregroundColor: UIColor.white
            ]
        )
        
        if let range = fullText.range(of: festivalName) {
            let nsRange = NSRange(range, in: fullText)
            attributed.addAttribute(
                .font,
                value: UIFont.boldSystemFont(ofSize: 24),
                range: nsRange
            )
        }
        
        return attributed
    }
}
