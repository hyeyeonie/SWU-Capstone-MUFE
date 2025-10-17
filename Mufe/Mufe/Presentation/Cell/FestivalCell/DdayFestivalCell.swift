//
//  DdayFestivalCell.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

final class DdayFestivalCell: UICollectionViewCell {
    
    static let identifier = "DdayFestivalCell"
    
    private var timer: Timer?
    
    private var startTime: String = "00:00"
    private var endTime: String = "00:00"
    
    private var isCurrentStage: Bool {
        let now = Date()
        let calendar = Calendar.current
        
        // 오늘 날짜의 00:00:00 시점을 기준으로 사용
        let todayStart = calendar.startOfDay(for: now)
        
        // "HH:mm" 문자열을 DateComponents로 파싱
        let startComponents = DateComponents(hour: Int(startTime.prefix(2)), minute: Int(startTime.suffix(2)))
        let endComponents = DateComponents(hour: Int(endTime.prefix(2)), minute: Int(endTime.suffix(2)))
        
        // 오늘 날짜와 공연 시간을 합쳐서 정확한 Date 객체를 만듭니다.
        guard let start = calendar.date(byAdding: startComponents, to: todayStart),
              let end = calendar.date(byAdding: endComponents, to: todayStart) else {
            return false
        }
        
        // 이제 날짜와 시간이 모두 정확하므로, 비교가 올바르게 동작합니다.
        return now >= start && now < end
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
        $0.customFont(.flg_Bold)
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
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
    
    @objc private func updateCurrent() {
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
    
    func configure(with timetable: SavedTimetable) {
        // 1. 시간 정보 업데이트
        self.startTime = timetable.startTime
        self.endTime = timetable.endTime
        runningTime.text = "\(startTime) - \(endTime)"
        duration.text = "\(timetable.runningTime)분"
        
        // 2. 아티스트 정보 업데이트
        artistName.text = timetable.artistName
        artistImage.image = UIImage(named: timetable.artistImage)
        
        // 3. 스테이지 정보 업데이트
        stageNumber.text = timetable.stage
        stageName.text = timetable.location
        
        // 4. 모든 정보가 설정된 후, '진행 중' UI 상태를 업데이트
        updateCurrent()
        
        startTimer()
    }
    
    private func startTimer() {
        // 기존 타이머가 있다면 중지
        timer?.invalidate()
        // 1분(60초)마다 updateCurrent 함수를 실행하는 타이머를 설정
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateCurrent), userInfo: nil, repeats: true)
    }
}
