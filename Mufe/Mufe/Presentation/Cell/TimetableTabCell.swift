//
//  TimetableTabCell.swift
//  Mufe
//
//  Created by 신혜연 on 10/15/25.
//

import UIKit

final class TimetableTabCell: UICollectionViewCell {
    
    static let identifier = "TimetableTabCell"
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private let fstNameLabel = UILabel().then {
        $0.customFont(.flg_Bold)
        $0.textColor = .gray10
        $0.numberOfLines = 2
    }
    
    private let fstDateLabel = UILabel().then {
        $0.customFont(.fsm_Medium)
        $0.textColor = .gray20
    }
    private let fstLocationLabel = UILabel().then {
        $0.customFont(.fsm_Medium)
        $0.textColor = .gray40
    }
    
    private let dayTagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fill
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray90
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with festival: Festival)  {
        posterImageView.image = UIImage(named: festival.imageName)
        fstNameLabel.text = festival.name
        fstDateLabel.text = "\(festival.startDate) - \(festival.endDate)"
        fstLocationLabel.text = festival.location
        
        dayTagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 0..<festival.days.count {
            let dayNumber = i + 1
            let tag = Daytag()
            tag.configure(day: dayNumber)
            dayTagStackView.addArrangedSubview(tag)
        }
    }
    
    private func setUI() {
        contentView.addSubviews(
            posterImageView,
            fstNameLabel,
            fstDateLabel,
            fstLocationLabel,
            dayTagStackView,
            dividerView
        )
    }
    
    private func setLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(78)
            $0.height.equalTo(104)
        }
        
        fstNameLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
        }
        
        fstDateLabel.snp.makeConstraints {
            $0.top.equalTo(fstNameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(fstNameLabel)
        }
        
        fstLocationLabel.snp.makeConstraints {
            $0.top.equalTo(fstDateLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(fstNameLabel)
        }
        
        dayTagStackView.snp.makeConstraints {
            $0.top.equalTo(fstLocationLabel.snp.bottom).offset(15)
            $0.leading.equalTo(fstNameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
