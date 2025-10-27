//
//  MadeTimetableCell.swift
//  Mufe
//
//  Created by 신혜연 on 10/2/25.
//

import UIKit
import SnapKit
import Then

final class MadeTimetableCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "MadeTimetableCell"
    
    // MARK: - UI Components
    
    private let stageNumber = UILabel().then {
        $0.customFont(.fmd_Bold)
        $0.textColor = .gray00
    }
    
    private let stageName = UILabel().then {
        $0.customFont(.fmd_Medium)
        $0.textColor = .gray40
    }
    
    private let contentContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .gray90
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        contentView.addSubviews(stageNumber, stageName, contentContainerView)
        
        stageNumber.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        stageName.snp.makeConstraints {
            $0.centerY.equalTo(stageNumber)
            $0.leading.equalTo(stageNumber.snp.trailing).offset(8)
        }
        
        contentContainerView.snp.makeConstraints {
            $0.top.equalTo(stageNumber.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Configure
    
    func configure(stageNumber: String, stageName: String, artists: [ArtistSchedule]) {
        self.stageNumber.text = stageNumber
        self.stageName.text = stageName
        
        contentContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for artist in artists {
            let artistView = createArtistView(for: artist)
            contentContainerView.addArrangedSubview(artistView)
        }
    }
    
    private func createArtistView(for artist: ArtistSchedule) -> UIView {
        let container = UIView()
        
        let artistImage = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 27
            $0.image = UIImage(named: artist.image) ?? UIImage(resource: .artistDefault)
        }
        
        let artistNameLabel = UILabel().then {
            $0.customFont(.flg_Bold)
            $0.textColor = .gray00
            $0.text = artist.name
        }
        
        let timeLabel = UILabel().then {
            $0.customFont(.fmd_Medium)
            $0.textColor = .gray40
            $0.text = "\(artist.startTime) - \(artist.endTime)  \(artist.duration)분"
        }
        
        container.addSubviews(artistImage, artistNameLabel, timeLabel)
        
        artistImage.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.size.equalTo(54)
        }
        
        artistNameLabel.snp.makeConstraints {
            $0.top.equalTo(artistImage)
            $0.leading.equalTo(artistImage.snp.trailing).offset(12)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(artistNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(artistNameLabel)
            $0.bottom.equalToSuperview()
        }
        
        return container
    }
}
