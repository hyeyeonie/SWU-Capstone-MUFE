//
//  FestivalCell.swift
//  Mufe
//
//  Created by 신혜연 on 5/28/25.
//

import UIKit

protocol FestivalSelectionDelegate: AnyObject {
    func didSelectFestival(_ festival: Festival)
}

final class FestivalCell: UICollectionViewCell {
    
    static let identifier = "FestivalCollectionViewCell"
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private let fstNameLabel = UILabel().then {
        $0.customFont(.flg_Bold)
        $0.textColor = .gray00
        $0.numberOfLines = 2
    }
    
    private let fstDateLabel = UILabel().then {
        $0.customFont(.fsm_Medium)
        $0.textColor = .gray50
    }
    private let fstLocationLabel = UILabel().then {
        $0.customFont(.fsm_Medium)
        $0.textColor = .gray50
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with festival: Festival) {
        let image = UIImage(named: festival.imageName)
        posterImageView.image = image ?? UIImage(named: "festival_default")
        fstNameLabel.text = festival.name
        fstDateLabel.text = "\(festival.startDate) - \(festival.endDate)"
        fstLocationLabel.text = festival.location
    }
    
    private func setUI() {
        contentView.addSubviews(
            posterImageView,
            fstNameLabel,
            fstDateLabel,
            fstLocationLabel
        )
    }
    
    private func setLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
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
    }
}
