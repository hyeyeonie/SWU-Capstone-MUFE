//
//  LoadingView.swift
//  Mufe
//
//  Created by 신혜연 on 6/15/25.
//

import UIKit

import SnapKit
import Then

final class LoadingView: UIView {
    
    private let lodingImageView = UIImageView().then {
        $0.image = UIImage(named: "loading")
        $0.contentMode = .scaleAspectFit
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
        addSubviews(lodingImageView, findingLabel, scriptLabel)
    }
    
    private func setLayout() {
        lodingImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(344)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(120)
        }
        
        findingLabel.snp.makeConstraints {
            $0.top.equalTo(lodingImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(lodingImageView)
        }
        
        scriptLabel.snp.makeConstraints {
            $0.top.equalTo(findingLabel.snp.bottom).offset(4)
            $0.centerX.equalTo(lodingImageView)
        }
    }
}
