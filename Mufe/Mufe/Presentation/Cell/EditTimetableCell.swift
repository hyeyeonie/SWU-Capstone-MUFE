//
//  EditTimetableCell.swift
//  Mufe
//
//  Created by 신혜연 on 11/19/25.
//

import UIKit

final class EditTimetableCell: UICollectionViewCell {
    
    static let identifier = "EditTimetableCell"
    
    override var isSelected: Bool {
        didSet {
            updateSelectionUI()
        }
    }
    
    private let artistLabel = UILabel().then {
        $0.customFont(.fsm_Bold)
        $0.textColor = .white
    }
    
    private let runningTimeLabel = UILabel().then {
        $0.customFont(.fxs_Regular)
        $0.textColor = .gray20
    }
    
    private let durationLabel = UILabel().then {
        $0.customFont(.fxs_Regular)
        $0.textColor = .gray20
    }
    
    private let checkButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(resource: .checkArtist), for: .normal)
        $0.isHidden = false
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        updateSelectionUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .gray80
        layer.cornerRadius = 12
    }
    
    private func setUI() {
        contentView.addSubviews(artistLabel, runningTimeLabel,
                                durationLabel, checkButton)
    }
    
    private func setLayout() {
        artistLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(12)
        }
        
        runningTimeLabel.snp.makeConstraints {
            $0.top.equalTo(artistLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalTo(artistLabel)
        }
        
        durationLabel.snp.makeConstraints {
            $0.top.equalTo(runningTimeLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalTo(runningTimeLabel)
        }
        
        checkButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(8)
            $0.size.equalTo(20)
        }
    }
    
    private func updateSelectionUI() {
        if isSelected {
            layer.borderWidth = 1
            layer.borderColor = UIColor.primary50.cgColor
            checkButton.isHidden = false
        } else {
            layer.borderWidth = 0
            layer.borderColor = nil
            checkButton.isHidden = true
        }
    }
    
    func configure(with schedule: ArtistSchedule) {
        artistLabel.text = schedule.name
        runningTimeLabel.text = "\(schedule.startTime) - \(schedule.endTime)"
        let startTimeComponents = schedule.startTime.split(separator: ":").compactMap { Int($0) }
        let endTimeComponents = schedule.endTime.split(separator: ":").compactMap { Int($0) }
        
        if startTimeComponents.count == 2 && endTimeComponents.count == 2 {
            let startMinutes = startTimeComponents[0] * 60 + startTimeComponents[1]
            let endMinutes = endTimeComponents[0] * 60 + endTimeComponents[1]
            let duration = endMinutes - startMinutes
            durationLabel.text = "\(duration)분"
        } else {
            durationLabel.text = ""
        }
    }
}
