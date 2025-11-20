//
//  SupplementaryViews.swift
//  Mufe
//
//  Created by 신혜연 on 11/19/25.
//

import UIKit
import SnapKit
import Then

// 상단 스테이지 헤더
class StageHeaderView: UICollectionReusableView {
    static let identifier = "StageHeaderView"
    let titleLabel = UILabel().then {
        $0.textColor = .gray20
        $0.customFont(.fsm_SemiBold)
        $0.textAlignment = .center
    }
    
    let locationLabel = UILabel().then {
        $0.textColor = .gray20
        $0.customFont(.fxs_Regular)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .grayBg
        
        addSubviews(titleLabel, locationLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(stage: String, location: String) {
        titleLabel.text = stage
        locationLabel.text = location
    }
}

// 좌측 시간 라벨
class TimeLabelView: UICollectionReusableView {
    static let identifier = "TimeLabelView"
    let timeLabel = UILabel().then {
        $0.textColor = .gray20
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .grayBg
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { $0.top.centerX.equalToSuperview() }
    }
    required init?(coder: NSCoder) { fatalError() }
}

// 좌측 상단 빈공간
class CornerHeaderView: UICollectionReusableView {
    static let identifier = "CornerHeaderView"
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .grayBg
    }
    required init?(coder: NSCoder) { fatalError() }
}
