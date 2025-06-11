//
//  TimetableCell.swift
//  Mufe
//
//  Created by 신혜연 on 6/10/25.
//

import UIKit

final class TimetableCell: UICollectionViewCell {
    
    static let identifier = "TimetableCell"
    
    private let artistImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .gray00
        $0.customFont(.flg_Bold)
    }
    
    private let locationIcon = UIImageView().then {
        $0.image = UIImage(systemName: "mappin.and.ellipse")
        $0.tintColor = .gray60
    }
    
    private let locationLabel = UILabel().then {
        $0.textColor = .gray40
        $0.customFont(.fmd_Regular)
    }
    
    private let timeIcon = UIImageView().then {
        $0.image = UIImage(systemName: "clock.fill")
        $0.tintColor = .gray60
    }
    
    private let timeLabel = UILabel().then {
        $0.textColor = .gray40
        $0.customFont(.fmd_Regular)
    }
    
    private let ticketLine = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ticketLine2")
    }
    
    private let genreLabel = UILabel().then {
        $0.textColor = .gray30
        $0.customFont(.fmd_Medium)
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
        layer.cornerRadius = 16
    }
    
    private func setUI() {
        addSubviews(
            artistImageView, nameLabel,
            locationIcon, locationLabel,
            timeIcon, timeLabel,
            ticketLine, genreLabel
        )
    }
    
    private func setLayout() {
        artistImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
            $0.size.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(artistImageView)
            $0.leading.equalTo(artistImageView.snp.trailing).offset(12)
        }
        
        locationIcon.snp.makeConstraints {
            $0.leading.equalTo(artistImageView)
            $0.top.equalTo(artistImageView.snp.bottom).offset(13)
            $0.size.equalTo(16)
        }
        
        locationLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationIcon)
            $0.leading.equalTo(locationIcon.snp.trailing).offset(4)
        }
        
        timeIcon.snp.makeConstraints {
            $0.leading.equalTo(artistImageView)
            $0.top.equalTo(locationIcon.snp.bottom).offset(13)
            $0.size.equalTo(16)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeIcon)
            $0.leading.equalTo(timeIcon.snp.trailing).offset(4)
        }
        
        ticketLine.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(ticketLine.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(25)
        }
    }
    
    func configure(with data: Timetable) {
        nameLabel.text = data.artistName
        locationLabel.text = data.location
        timeLabel.text = "\(data.startTime) - \(data.endTime), \(data.runningTime)분"
        genreLabel.text = data.script
        artistImageView.image = UIImage(named: data.imageName) ?? UIImage(named: "artistImg")
    }
    
    func hasFinalConsonant(_ word: String) -> Bool {
        guard let last = word.last else { return false }
        let scalarValue = UnicodeScalar(String(last))?.value ?? 0
        
        // 한글 유니코드 범위: AC00 ~ D7A3
        if scalarValue < 0xAC00 || scalarValue > 0xD7A3 { return false }
        let index = scalarValue - 0xAC00
        let jongseong = index % 28
        return jongseong != 0
    }
}
