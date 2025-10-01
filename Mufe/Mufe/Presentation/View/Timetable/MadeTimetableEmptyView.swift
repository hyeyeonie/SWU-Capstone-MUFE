//
//  MadeTimetableEmptyView.swift
//  Mufe
//
//  Created by 신혜연 on 10/2/25.
//

import UIKit

import SnapKit
import Then

final class MadeTimetableEmptyView: UIView {
    
    private let emptyView = emptyFestivalView().then {
        $0.setContentText("아직 시간표를 등록하지 않았어요")
        $0.setImageSize(140)
    }
    
    private let registerFestButton = UIButton().then {
        $0.setTitle("시간표 등록하기", for: .normal)
        $0.titleLabel?.customFont(.fmd_Bold)
        $0.layer.cornerRadius = 8
        $0.setTitleColor(.gray80, for: .normal)
        $0.backgroundColor = .gray05
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubviews(emptyView, registerFestButton)
    }
    
    private func setLayout() {
        emptyView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(76)
            $0.centerX.equalToSuperview()
        }
        
        registerFestButton.snp.makeConstraints{
            $0.top.equalTo(emptyView.snp.bottom).offset(210)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(123)
            $0.height.equalTo(34)
        }
    }
}

#Preview {
    MadeTimetableEmptyView()
}
