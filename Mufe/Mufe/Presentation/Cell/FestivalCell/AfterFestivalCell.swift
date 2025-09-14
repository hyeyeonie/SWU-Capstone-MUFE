//
//  AfterFestivalCell.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

final class AfterFestivalCell: UICollectionViewCell {
    
    static let identifier = "AfterFestivalCell"
    
    private var startTime = "11:50"
    private var endTime = "12:20"
    
    private var isCurrentStage: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let now = Date()
        
        guard
            let start = formatter.date(from: startTime),
            let end = formatter.date(from: endTime)
        else { return false }
        
        return now >= start && now <= end
    }
    
    private let stageNumber = UILabel().then {
        $0.customFont(.fmd_Bold)
        $0.text = "STAGE 1"
        $0.textColor = .gray00
    }
    
    private let stageName = UILabel().then {
        $0.customFont(.fmd_Medium)
        $0.text = "SOUND PLANET"
        $0.textColor = .gray40
    }
    
    private let contentContainerView = UIView()
    
    private let artistImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(resource: .artistImg)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 27
    }
    
    private let artistName = UILabel().then {
        $0.customFont(.fmd_Bold)
        $0.text = "Tuesday Beach Club"
        $0.textColor = .gray00
    }
    
    private let timeIcon = UIImageView().then {
        $0.image = UIImage(resource: .timeIcon)
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var runningTime = UILabel().then {
        $0.customFont(.fmd_Medium)
        $0.text = "\(startTime) - \(endTime)"
        $0.textColor = .gray40
    }
    
    private let duration = UILabel().then {
        $0.customFont(.fmd_Medium)
        $0.text = "30분" // TODO: runningTime 계산로직
        $0.textColor = .gray40
    }
    
    // 진행 중
    private let currentStageContainerView = UIView().then {
        $0.backgroundColor = .primary50
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.isHidden = true
    }
    
    private let currentStageLabel = UILabel().then {
        $0.customFont(.fsm_SemiBold)
        $0.text = "진행 중"
        $0.textColor = .gray00
    }
    
    private let currentStageBar = UIImageView().then {
        $0.image = UIImage(resource: .currentStageBar)
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        updateCurrent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        backgroundColor = .gray90
        layer.cornerRadius = 16
    }
    
    private func setUI() {
        addSubviews(
            stageNumber, stageName,
            contentContainerView,
            currentStageContainerView, currentStageBar
        )
        
        contentContainerView.addSubviews(
            artistImage, artistName,
            timeIcon, runningTime, duration
        )
        
        currentStageContainerView.addSubview(currentStageLabel)
    }
    
    private func setLayout() {
        stageNumber.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20)
        }
        
        stageName.snp.makeConstraints{
            $0.centerY.equalTo(stageNumber)
            $0.leading.equalTo(stageNumber.snp.trailing).offset(8)
        }
        
        artistImage.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview()
            $0.size.equalTo(54)
        }
        
        artistName.snp.makeConstraints{
            $0.top.equalTo(artistImage)
            $0.leading.equalTo(artistImage.snp.trailing).offset(12)
        }
        
        timeIcon.snp.makeConstraints{
            $0.top.equalTo(artistName.snp.bottom).offset(9)
            $0.leading.equalTo(artistName)
            $0.size.equalTo(16)
        }
        
        runningTime.snp.makeConstraints{
            $0.centerY.equalTo(timeIcon)
            $0.leading.equalTo(timeIcon.snp.trailing).offset(4)
        }
        
        duration.snp.makeConstraints {
            $0.centerY.equalTo(timeIcon)
            $0.leading.equalTo(runningTime.snp.trailing).offset(8)
        }
        
        currentStageContainerView.snp.makeConstraints {
            $0.top.equalTo(stageNumber.snp.bottom).offset(17)
            $0.leading.equalTo(stageNumber)
        }
        
        currentStageLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        currentStageBar.snp.makeConstraints {
            $0.top.equalTo(currentStageContainerView.snp.bottom).offset(8)
            $0.leading.equalTo(currentStageContainerView).inset(8)
        }
    }
    
    private func updateCurrent() {
        let isCurrent = isCurrentStage
        currentStageContainerView.isHidden = !isCurrent
        currentStageBar.isHidden = !isCurrent
        
        contentContainerView.snp.remakeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            
            if isCurrent {
                $0.top.equalTo(currentStageContainerView.snp.bottom).offset(8)
                $0.leading.equalTo(currentStageBar.snp.trailing).offset(17)
            } else {
                $0.top.equalTo(stageNumber.snp.bottom).offset(16)
                $0.leading.equalToSuperview().inset(20)
            }
        }
    }
    
    func configure(start: String, end: String) {
        self.startTime = start
        self.endTime = end
        runningTime.text = "\(startTime) - \(endTime)"
        updateCurrent()
    }
}
