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

    // MARK: - 3xl (32pt) - 150%
    static let f3xl_Regular: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.regular.rawValue, size: 32) ?? UIFont.systemFont(ofSize: 32)
        return CustomUIFont(font: font, lineSpacing: 10)
    }()
    static let f3xl_Medium: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.medium.rawValue, size: 32) ?? UIFont.systemFont(ofSize: 32)
        return CustomUIFont(font: font, lineSpacing: 10)
    }()
    static let f3xl_SemiBold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.semiBold.rawValue, size: 32) ?? UIFont.systemFont(ofSize: 32)
        return CustomUIFont(font: font, lineSpacing: 10)
    }()
    static let f3xl_Bold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.bold.rawValue, size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
        return CustomUIFont(font: font, lineSpacing: 10)
    }()

    // MARK: - 2xl (24pt) - 150%
    static let f2xl_Regular: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.regular.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24)
        return CustomUIFont(font: font, lineSpacing: 8)
    }()
    static let f2xl_Medium: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.medium.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24)
        return CustomUIFont(font: font, lineSpacing: 8)
    }()
    static let f2xl_SemiBold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.semiBold.rawValue, size: 24) ?? UIFont.systemFont(ofSize: 24)
        return CustomUIFont(font: font, lineSpacing: 8)
    }()
    static let f2xl_Bold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.bold.rawValue, size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
        return CustomUIFont(font: font, lineSpacing: 8)
    }()

    // MARK: - xl (20pt) - 150%
    static let fxl_Regular: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.regular.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20)
        return CustomUIFont(font: font, lineSpacing: 8)
    }()
    static let fxl_Medium: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.medium.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20)
        return CustomUIFont(font: font, lineSpacing: 8)
    }()
    static let fxl_SemiBold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.semiBold.rawValue, size: 20) ?? UIFont.systemFont(ofSize: 20)
        return CustomUIFont(font: font, lineSpacing: 8)
    }()
    static let fxl_Bold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.bold.rawValue, size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        return CustomUIFont(font: font, lineSpacing: 8)
    }()

    // MARK: - lg (18pt) - 150%
    static let flg_Regular: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.regular.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18)
        return CustomUIFont(font: font, lineSpacing: 7)
    }()
    static let flg_Medium: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.medium.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18)
        return CustomUIFont(font: font, lineSpacing: 7)
    }()
    static let flg_SemiBold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.semiBold.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18)
        return CustomUIFont(font: font, lineSpacing: 7)
    }()
    static let flg_Bold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.bold.rawValue, size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        return CustomUIFont(font: font, lineSpacing: 7)
    }()

    // MARK: - md (16pt) - 160%
    static let fmd_Regular: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.regular.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16)
        return CustomUIFont(font: font, lineSpacing: 6.4)
    }()
    static let fmd_Medium: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.medium.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16)
        return CustomUIFont(font: font, lineSpacing: 6.4)
    }()
    static let fmd_SemiBold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.semiBold.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16)
        return CustomUIFont(font: font, lineSpacing: 6.4)
    }()
    static let fmd_Bold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.bold.rawValue, size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
        return CustomUIFont(font: font, lineSpacing: 6.4)
    }()

    // MARK: - sm (14pt) - 150%
    static let fsm_Regular: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.regular.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)
        return CustomUIFont(font: font, lineSpacing: 4)
    }()
    static let fsm_Medium: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.medium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)
        return CustomUIFont(font: font, lineSpacing: 4)
    }()
    static let fsm_SemiBold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.semiBold.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)
        return CustomUIFont(font: font, lineSpacing: 4)
    }()
    static let fsm_Bold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.bold.rawValue, size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        return CustomUIFont(font: font, lineSpacing: 4)
    }()

    // MARK: - xs (12pt) - 120%
    static let fxs_Regular: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.regular.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12)
        return CustomUIFont(font: font, lineSpacing: 1.4)
    }()
    static let fxs_Medium: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.medium.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12)
        return CustomUIFont(font: font, lineSpacing: 1.4)
    }()
    static let fxs_SemiBold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.semiBold.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12)
        return CustomUIFont(font: font, lineSpacing: 1.4)
    }()
    static let fxs_Bold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.bold.rawValue, size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
        return CustomUIFont(font: font, lineSpacing: 1.4)
    }()

    // MARK: - 2xs (10pt) - 150%
    static let f2xs_Regular: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.regular.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10)
        return CustomUIFont(font: font, lineSpacing: 3)
    }()
    static let f2xs_Medium: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.medium.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10)
        return CustomUIFont(font: font, lineSpacing: 3)
    }()
    static let f2xs_SemiBold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.semiBold.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10)
        return CustomUIFont(font: font, lineSpacing: 3)
    }()
    static let f2xs_Bold: CustomUIFont = {
        let font = UIFont(name: PretendardStyle.bold.rawValue, size: 10) ?? UIFont.boldSystemFont(ofSize: 10)
        return CustomUIFont(font: font, lineSpacing: 3)
    }()
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
