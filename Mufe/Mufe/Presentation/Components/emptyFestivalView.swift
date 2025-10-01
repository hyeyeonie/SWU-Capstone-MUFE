//
//  emptyFestivalView.swift
//  Mufe
//
//  Created by 신혜연 on 10/1/25.
//

import UIKit

import SnapKit
import Then

final class emptyFestivalView: UIView {
    
    private let mufeImageView = UIImageView().then {
        $0.image = UIImage(resource: .character)
        $0.contentMode = .scaleAspectFit
    }
    
    private(set) var contentLabel = UILabel().then {
        $0.customFont(.fmd_Medium)
        $0.textColor = .gray40
        $0.textAlignment = .center
        $0.numberOfLines = 2
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
        addSubviews(mufeImageView, contentLabel)
    }
    
    private func setLayout() {
        mufeImageView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(191)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(160)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(mufeImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setContentText(_ text: String) {
        contentLabel.text = text
    }
}
