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
        switch self {
        case .festivalSelection:
            fullText = "어떤 페스티벌에\n참여하실 예정인가요?"
        case .dateSelection:
            fullText = "\(festivalName) 에\n언제 방문하실 예정인가요?"
        case .timeSelection:
            fullText = "\(festivalName) 에\n얼마나 머무르시나요?"
        case .artistSelection:
            fullText = "\(festivalName) 에\n꼭 보고 싶은 무대가 있나요?"
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = customFont.lineSpacing
        
        let attributed = NSMutableAttributedString(string: fullText)
        
        switch self {
        case .dateSelection, .timeSelection, .artistSelection:
            // festivalName 범위
            if let festivalRange = fullText.range(of: festivalName) {
                let nsFestivalRange = NSRange(festivalRange, in: fullText)
                
                // festivalName 스타일: f2xl_Bold + gray00
                attributed.addAttributes([
                    .font: CustomUIFont.f2xl_Bold.font,
                    .foregroundColor: UIColor.gray00,
                    .paragraphStyle: paragraphStyle
                ], range: nsFestivalRange)
                
                // 나머지 텍스트 스타일: f2xl_Medium + gray20
                let fullNSRange = NSRange(fullText.startIndex..<fullText.endIndex, in: fullText)
                
                attributed.addAttributes([
                    .font: CustomUIFont.f2xl_Medium.font,
                    .foregroundColor: UIColor.gray20,
                    .paragraphStyle: paragraphStyle
                ], range: fullNSRange)
                
                // festivalName 부분을 덮어씌우기 (우선순위 때문에)
                attributed.addAttributes([
                    .font: CustomUIFont.f2xl_Bold.font,
                    .foregroundColor: UIColor.gray00,
                    .paragraphStyle: paragraphStyle
                ], range: nsFestivalRange)
                
            } else {
                // festivalName 못찾으면 전체에 medium+gray20 적용
                let fullNSRange = NSRange(fullText.startIndex..<fullText.endIndex, in: fullText)
                attributed.addAttributes([
                    .font: CustomUIFont.f2xl_Medium.font,
                    .foregroundColor: UIColor.gray20,
                    .paragraphStyle: paragraphStyle
                ], range: fullNSRange)
            }
            
        default:
            // 나머지 step: 전체에 f2xl_Bold + gray00 적용
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
