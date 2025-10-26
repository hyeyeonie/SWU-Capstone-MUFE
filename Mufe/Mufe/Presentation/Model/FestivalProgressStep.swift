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
    
    func attributedTitle(with festivalName: String, customFont: CustomUIFont) -> NSAttributedString {
        let fullText: String
        let nonBreakingSpace = "\u{00A0}"
        
        switch self {
        case .festivalSelection:
            fullText = "어떤 페스티벌에\n참여하실 예정인가요?"
        case .dateSelection:
            fullText = "\(festivalName)\(nonBreakingSpace)에\n언제 방문하실 예정인가요?"
        case .timeSelection:
            fullText = "\(festivalName)\(nonBreakingSpace)에\n얼마나 머무르시나요?"
        case .artistSelection:
            fullText = "\(festivalName)\(nonBreakingSpace)에\n꼭 보고 싶은 무대가 있나요?"
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = customFont.lineSpacing
        
        let attributed = NSMutableAttributedString(string: fullText)
        
        switch self {
        case .dateSelection, .timeSelection, .artistSelection:
            if let festivalRange = fullText.range(of: festivalName) {
                let nsFestivalRange = NSRange(festivalRange, in: fullText)
                
                attributed.addAttributes([
                    .font: CustomUIFont.f2xl_Bold.font,
                    .foregroundColor: UIColor.gray00,
                    .paragraphStyle: paragraphStyle
                ], range: nsFestivalRange)
                
                let fullNSRange = NSRange(fullText.startIndex..<fullText.endIndex, in: fullText)
                
                attributed.addAttributes([
                    .font: CustomUIFont.f2xl_Medium.font,
                    .foregroundColor: UIColor.gray20,
                    .paragraphStyle: paragraphStyle
                ], range: fullNSRange)
                
                attributed.addAttributes([
                    .font: CustomUIFont.f2xl_Bold.font,
                    .foregroundColor: UIColor.gray00,
                    .paragraphStyle: paragraphStyle
                ], range: nsFestivalRange)
                
            } else {
                let fullNSRange = NSRange(fullText.startIndex..<fullText.endIndex, in: fullText)
                attributed.addAttributes([
                    .font: CustomUIFont.f2xl_Medium.font,
                    .foregroundColor: UIColor.gray20,
                    .paragraphStyle: paragraphStyle
                ], range: fullNSRange)
            }
            
        default:
            let fullNSRange = NSRange(fullText.startIndex..<fullText.endIndex, in: fullText)
            attributed.addAttributes([
                .font: customFont.font,
                .foregroundColor: UIColor.gray00,
                .paragraphStyle: paragraphStyle
            ], range: fullNSRange)
        }
        
        return attributed
    }
    
    func previous() -> FestivalProgressStep? {
        switch self {
        case .festivalSelection:
            return nil
        case .dateSelection:
            return .festivalSelection
        case .timeSelection:
            return .dateSelection
        case .artistSelection:
            return .timeSelection
        }
    }
    
    func next() -> FestivalProgressStep? {
        switch self {
        case .festivalSelection: return .dateSelection
        case .dateSelection: return .timeSelection
        case .timeSelection: return .artistSelection
        case .artistSelection: return nil
        }
    }
}
