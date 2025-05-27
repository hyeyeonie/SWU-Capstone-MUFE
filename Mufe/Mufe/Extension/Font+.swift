//
//  Font+.swift
//  Mufe
//
//  Created by 최하늘 on 5/27/25.
//

import SwiftUI

struct CustomFont {
    let font: Font
    let lineSpacing: CGFloat
    
    // 3xl
    static let f3xl_Regular = CustomFont(font: .custom("Pretendard-Regular", size: 32), lineSpacing: (32*0.375))
    static let f3xl_Medium = CustomFont(font: .custom("Pretendard-Medium", size: 32), lineSpacing: (32*0.375))
    static let f3xl_SemiBold = CustomFont(font: .custom("Pretendard-SemiBold", size: 32), lineSpacing: (32*0.375))
    static let f3xl_Bold = CustomFont(font: .custom("Pretendard-Bold", size: 32), lineSpacing: (32*0.375))
    
    // 2xl
    static let f2xl_Regular = CustomFont(font: .custom("Pretendard-Regular", size: 24), lineSpacing: (24*0.375))
    static let f2xl_Medium = CustomFont(font: .custom("Pretendard-Medium", size: 24), lineSpacing: (24*0.375))
    static let f2xl_SemiBold = CustomFont(font: .custom("Pretendard-SemiBold", size: 24), lineSpacing: (24*0.375))
    static let f2xl_Bold = CustomFont(font: .custom("Pretendard-Bold", size: 24), lineSpacing: (24*0.375))
    
    // xl
    static let fxl_Regular = CustomFont(font: .custom("Pretendard-Regular", size: 20), lineSpacing: (20*0.375))
    static let fxl_Medium = CustomFont(font: .custom("Pretendard-Medium", size: 20), lineSpacing: (20*0.375))
    static let fxl_SemiBold = CustomFont(font: .custom("Pretendard-SemiBold", size: 20), lineSpacing: (20*0.375))
    static let fxl_Bold = CustomFont(font: .custom("Pretendard-Bold", size: 20), lineSpacing: (20*0.375))
    
    // lg
    static let flg_Regular = CustomFont(font: .custom("Pretendard-Regular", size: 18), lineSpacing: (18*0.375))
    static let flg_Medium = CustomFont(font: .custom("Pretendard-Medium", size: 18), lineSpacing: (18*0.375))
    static let flg_SemiBold = CustomFont(font: .custom("Pretendard-SemiBold", size: 18), lineSpacing: (18*0.375))
    static let flg_Bold = CustomFont(font: .custom("Pretendard-Bold", size: 18), lineSpacing: (18*0.375))
    
    // md
    static let fmd_Regular = CustomFont(font: .custom("Pretendard-Regular", size: 16), lineSpacing: (16*0.375))
    static let fmd_Medium = CustomFont(font: .custom("Pretendard-Medium", size: 16), lineSpacing: (16*0.375))
    static let fmd_SemiBold = CustomFont(font: .custom("Pretendard-SemiBold", size: 16), lineSpacing: (16*0.375))
    static let fmd_Bold = CustomFont(font: .custom("Pretendard-Bold", size: 16), lineSpacing: (16*0.375))
    
    // sm
    static let fsm_Regular = CustomFont(font: .custom("Pretendard-Regular", size: 14), lineSpacing: (14*0.375))
    static let fsm_Medium = CustomFont(font: .custom("Pretendard-Medium", size: 14), lineSpacing: (14*0.375))
    static let fsm_SemiBold = CustomFont(font: .custom("Pretendard-SemiBold", size: 14), lineSpacing: (14*0.375))
    static let fsm_Bold = CustomFont(font: .custom("Pretendard-Bold", size: 14), lineSpacing: (14*0.375))
    
    // xs
    static let fxs_Regular = CustomFont(font: .custom("Pretendard-Regular", size: 12), lineSpacing: (12*0.375))
    static let fxs_Medium = CustomFont(font: .custom("Pretendard-Medium", size: 12), lineSpacing: (12*0.375))
    static let fxs_SemiBold = CustomFont(font: .custom("Pretendard-SemiBold", size: 12), lineSpacing: (12*0.375))
    static let fxs_Bold = CustomFont(font: .custom("Pretendard-Bold", size: 12), lineSpacing: (12*0.375))
    
    // 2xs
    static let f2xs_Regular = CustomFont(font: .custom("Pretendard-Regular", size: 10), lineSpacing: (10*0.375))
    static let f2xs_Medium = CustomFont(font: .custom("Pretendard-Medium", size: 10), lineSpacing: (10*0.375))
    static let f2xs_SemiBold = CustomFont(font: .custom("Pretendard-SemiBold", size: 10), lineSpacing: (10*0.375))
    static let f2xs_Bold = CustomFont(font: .custom("Pretendard-Bold", size: 10), lineSpacing: (10*0.375))
}

extension Text {
    func customFont(_ customFont: CustomFont) -> some View {
        self
            .font(customFont.font)
            .lineSpacing(customFont.lineSpacing)
    }
}

extension Label {
    func customFont(_ customFont: CustomFont) -> some View {
        self
            .font(customFont.font)
            .lineSpacing(customFont.lineSpacing)
    }
}

extension TextField {
    func customFont(_ customFont: CustomFont) -> some View {
        self
            .font(customFont.font)
            .lineSpacing(customFont.lineSpacing)
    }
}


extension VStack {
    func customFont(_ customFont: CustomFont) -> some View {
        self
            .font(customFont.font)
            .lineSpacing(customFont.lineSpacing)
    }
}

extension HStack {
    func customFont(_ customFont: CustomFont) -> some View {
        self
            .font(customFont.font)
            .lineSpacing(customFont.lineSpacing)
    }
}
