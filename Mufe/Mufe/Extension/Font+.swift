//
//  Font+.swift
//  Mufe
//
//  Created by 최하늘 on 5/27/25.
//

import UIKit

enum PretendardStyle: String {
    case regular = "Pretendard-Regular"
    case medium = "Pretendard-Medium"
    case semiBold = "Pretendard-SemiBold"
    case bold = "Pretendard-Bold"
}

struct CustomUIFont {
    let font: UIFont
    let lineSpacing: CGFloat
    
    // 3xl (32pt)
    static let f3xl_Regular = CustomUIFont(font: UIFont(name: PretendardStyle.regular.rawValue, size: 32) ?? UIFont.systemFont(ofSize: 32), lineSpacing: 32 * 0.375)
    static let f3xl_Medium = CustomUIFont(font: UIFont(name: PretendardStyle.medium.rawValue, size: 32) ?? UIFont.systemFont(ofSize: 32), lineSpacing: 32 * 0.375)
    static let f3xl_SemiBold = CustomUIFont(font: UIFont(name: PretendardStyle.semiBold.rawValue, size: 32) ?? UIFont.systemFont(ofSize: 32), lineSpacing: 32 * 0.375)
    static let f3xl_Bold = CustomUIFont(font: UIFont(name: PretendardStyle.bold.rawValue, size: 32) ?? UIFont.boldSystemFont(ofSize: 32), lineSpacing: 32 * 0.375)

    // 2xl (24pt)
    static let f2xl_Regular = CustomUIFont(font: UIFont(name: PretendardStyle.regular.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24), lineSpacing: 24 * 0.375)
    static let f2xl_Medium = CustomUIFont(font: UIFont(name: PretendardStyle.medium.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24), lineSpacing: 24 * 0.375)
    static let f2xl_SemiBold = CustomUIFont(font: UIFont(name: PretendardStyle.semiBold.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24), lineSpacing: 24 * 0.375)
    static let f2xl_Bold = CustomUIFont(font: UIFont(name: PretendardStyle.bold.rawValue, size: 24) ?? UIFont.boldSystemFont(ofSize: 24), lineSpacing: 24 * 0.375)
    
    // xl
    static let fxl_Regular = CustomUIFont(
        font: UIFont(name: "Pretendard-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .regular),
        lineSpacing: 20 * 0.375
    )
    static let fxl_Medium = CustomUIFont(
        font: UIFont(name: "Pretendard-Medium", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .medium),
        lineSpacing: 20 * 0.375
    )
    static let fxl_SemiBold = CustomUIFont(
        font: UIFont(name: "Pretendard-SemiBold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold),
        lineSpacing: 20 * 0.375
    )
    static let fxl_Bold = CustomUIFont(
        font: UIFont(name: "Pretendard-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold),
        lineSpacing: 20 * 0.375
    )

    // lg (18pt)
    static let flg_Regular = CustomUIFont(font: UIFont(name: PretendardStyle.regular.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18), lineSpacing: 18 * 0.375)
    static let flg_Medium = CustomUIFont(font: UIFont(name: PretendardStyle.medium.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18), lineSpacing: 18 * 0.375)
    static let flg_SemiBold = CustomUIFont(font: UIFont(name: PretendardStyle.semiBold.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18), lineSpacing: 18 * 0.375)
    static let flg_Bold = CustomUIFont(font: UIFont(name: PretendardStyle.bold.rawValue, size: 18) ?? UIFont.boldSystemFont(ofSize: 18), lineSpacing: 18 * 0.375)

    // md (16pt)
    static let fmd_Regular = CustomUIFont(font: UIFont(name: PretendardStyle.regular.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16), lineSpacing: 16 * 0.375)
    static let fmd_Medium = CustomUIFont(font: UIFont(name: PretendardStyle.medium.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16), lineSpacing: 16 * 0.375)
    static let fmd_SemiBold = CustomUIFont(font: UIFont(name: PretendardStyle.semiBold.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16), lineSpacing: 16 * 0.375)
    static let fmd_Bold = CustomUIFont(font: UIFont(name: PretendardStyle.bold.rawValue, size: 16) ?? UIFont.boldSystemFont(ofSize: 16), lineSpacing: 16 * 0.375)

    // sm (14pt)
    static let fsm_Regular = CustomUIFont(font: UIFont(name: PretendardStyle.regular.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14), lineSpacing: 14 * 0.375)
    static let fsm_Medium = CustomUIFont(font: UIFont(name: PretendardStyle.medium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14), lineSpacing: 14 * 0.375)
    static let fsm_SemiBold = CustomUIFont(font: UIFont(name: PretendardStyle.semiBold.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14), lineSpacing: 14 * 0.375)
    static let fsm_Bold = CustomUIFont(font: UIFont(name: PretendardStyle.bold.rawValue, size: 14) ?? UIFont.boldSystemFont(ofSize: 14), lineSpacing: 14 * 0.375)

    // xs (12pt)
    static let fxs_Regular = CustomUIFont(font: UIFont(name: PretendardStyle.regular.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12), lineSpacing: 12 * 0.375)
    static let fxs_Medium = CustomUIFont(font: UIFont(name: PretendardStyle.medium.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12), lineSpacing: 12 * 0.375)
    static let fxs_SemiBold = CustomUIFont(font: UIFont(name: PretendardStyle.semiBold.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12), lineSpacing: 12 * 0.375)
    static let fxs_Bold = CustomUIFont(font: UIFont(name: PretendardStyle.bold.rawValue, size: 12) ?? UIFont.boldSystemFont(ofSize: 12), lineSpacing: 12 * 0.375)

    // 2xs (10pt)
    static let f2xs_Regular = CustomUIFont(font: UIFont(name: PretendardStyle.regular.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10), lineSpacing: 10 * 0.375)
    static let f2xs_Medium = CustomUIFont(font: UIFont(name: PretendardStyle.medium.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10), lineSpacing: 10 * 0.375)
    static let f2xs_SemiBold = CustomUIFont(font: UIFont(name: PretendardStyle.semiBold.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10), lineSpacing: 10 * 0.375)
    static let f2xs_Bold = CustomUIFont(font: UIFont(name: PretendardStyle.bold.rawValue, size: 10) ?? UIFont.boldSystemFont(ofSize: 10), lineSpacing: 10 * 0.375)
}

// UILabel, UITextView 등에서 lineSpacing 적용용 헬퍼 (NSAttributedString)

extension UILabel {
    func customFont(_ customFont: CustomUIFont, with text: String? = nil) {
        self.font = customFont.font
        if let text = text ?? self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = customFont.lineSpacing
            
            let attrString = NSMutableAttributedString(string: text)
            attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
            
            self.attributedText = attrString
        }
    }
}

extension UITextView {
    func customFont(_ customFont: CustomUIFont) {
        self.font = customFont.font
        
        if let text = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = customFont.lineSpacing
            
            let attrString = NSMutableAttributedString(string: text)
            attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
            
            self.attributedText = attrString
        }
    }
}
