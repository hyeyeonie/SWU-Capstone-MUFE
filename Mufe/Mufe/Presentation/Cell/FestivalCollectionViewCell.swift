//
//  FestivalCollectionViewCell.swift
//  Mufe
//
//  Created by 신혜연 on 5/28/25.
//

import UIKit

final class FestivalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FestivalCollectionViewCell"
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private let fstNameLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textColor = .white
    }
    
    private let fstDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray
    }
    private let fstLocationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray
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
        posterImageView.image = UIImage(named: festival.imageName)
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
