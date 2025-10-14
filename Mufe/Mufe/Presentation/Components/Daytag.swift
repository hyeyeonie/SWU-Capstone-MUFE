//
//  Daytag.swift
//  Mufe
//
//  Created by 신혜연 on 10/15/25.
//

import UIKit

import SnapKit
import Then

final class Daytag: UIControl {

    private(set) var dayTitle = UILabel().then {
        $0.customFont(.fxs_Regular)
        $0.text = "1일차"
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
        backgroundColor = .gray90
        layer.cornerRadius = 4
        layer.masksToBounds = true
    }
    
    private func setUI() {
        addSubviews(dayTitle)
    }
    
    private func setLayout() {
        snp.makeConstraints {
            $0.width.equalTo(34)
            $0.height.equalTo(20)
        }
        
        dayTitle.snp.makeConstraints{
            $0.top.equalToSuperview().inset(1)
            $0.center.equalToSuperview()
        }
    }
    
    func configure(day: Int) {
        dayTitle.text = "\(day)일차"
    }
}
