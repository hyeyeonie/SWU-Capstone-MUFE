//
//  LoadingView.swift
//  Mufe
//
//  Created by 신혜연 on 6/15/25.
//

import UIKit

import SnapKit
import Then
import Lottie

final class LoadingView: UIView {
    
    private let animationView = LottieAnimationView(name: "loading").then {
        $0.loopMode = .loop
        $0.contentMode = .scaleAspectFit
        $0.play()
    }
    
    private let findingLabel = UILabel().then {
        $0.text = "공연을 찾는 중.."
        $0.customFont(.fxl_Bold)
        $0.textColor = .gray00
    }
    
    private let scriptLabel = UILabel().then {
        $0.text = "당신의 취향에 꼭 맞는 무대를 찾고 있어요"
        $0.customFont(.fmd_Medium)
        $0.textColor = .gray40
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
        addSubviews(animationView, findingLabel, scriptLabel)
    }
    
    private func setLayout() {
        animationView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(284)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(160)
        }
        
        findingLabel.snp.makeConstraints {
            $0.top.equalTo(animationView.snp.bottom).offset(24)
            $0.centerX.equalTo(animationView)
        }
        
        scriptLabel.snp.makeConstraints {
            $0.top.equalTo(findingLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(animationView)
        }
    }
}
