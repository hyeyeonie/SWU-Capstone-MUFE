//
//  TimeCell.swift
//  Mufe
//
//  Created by 신혜연 on 6/4/25.
//

import UIKit

final class TimeCell: UICollectionViewCell {
    
    static let identifier = "TimeCell"
    
    private let dayLabel = UILabel().then {
        $0.customFont(.fxl_Bold)
        $0.textColor = .gray05
    }
    
    private let dateLabel = UILabel().then {
        $0.customFont(.fmd_Medium)
        $0.textColor = .gray40
    }
    
    private let ticketLine = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.image = UIImage(named: "ticketLine2")
    }
    
    private let enterTitle = UILabel().then {
        $0.text = "입장시간"
        $0.textColor = .gray00
        $0.customFont(.fmd_Medium)
    }
    
    private let leaveTitle = UILabel().then {
        $0.text = "퇴장시간"
        $0.textColor = .gray00
        $0.customFont(.fmd_Medium)
    }
    
    private let enterTimePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .inline
        $0.tintColor = .gray00
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    private let leaveTimePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .inline
        $0.tintColor = .gray00
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    private let wave = UILabel().then {
        $0.text = "~"
        $0.textColor = .gray00
        $0.customFont(.f3xl_Regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
        setDefaultTime()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: DateItem) {
        dayLabel.text = item.day
        dateLabel.text = item.date
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        
        if let enterDate = formatter.date(from: item.enterTime) {
            enterTimePicker.setDate(enterDate, animated: false)
            leaveTimePicker.minimumDate = enterDate
        }
        
        if let leaveDate = formatter.date(from: item.leaveTime) {
            leaveTimePicker.setDate(leaveDate, animated: false)
        }
    }
    
    private func setStyle() {
        backgroundColor = .gray90
        layer.cornerRadius = 16
    }
    
    private func setUI() {
        contentView.addSubviews(dayLabel, dateLabel, ticketLine,
                    enterTitle, leaveTitle,
                    enterTimePicker, leaveTimePicker, wave)
    }
    
    private func setLayout() {
        dayLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dayLabel)
            $0.leading.equalTo(dayLabel.snp.trailing).offset(8)
        }
        
        ticketLine.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        enterTitle.snp.makeConstraints {
            $0.top.equalTo(ticketLine.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(58.5)
        }
        
        leaveTitle.snp.makeConstraints {
            $0.centerY.equalTo(enterTitle)
            $0.trailing.equalToSuperview().inset(58.5)
        }

        enterTimePicker.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(28)
            $0.centerX.equalTo(enterTitle)
        }
        
        wave.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(46)
            $0.centerX.equalToSuperview()
        }
        
        leaveTimePicker.snp.makeConstraints {
            $0.centerY.equalTo(enterTimePicker)
            $0.centerX.equalTo(leaveTitle)
        }
    }
    
    private func setAction() {
        enterTimePicker.addTarget(self, action: #selector(enterTimeChanged), for: .valueChanged)
    }
    
    private func setDefaultTime() {
        let calendar = Calendar.current
        let now = Date()
        
        if let enterDate = calendar.date(bySettingHour: 11, minute: 30, second: 0, of: now),
           let leaveDate = calendar.date(bySettingHour: 22, minute: 30, second: 0, of: now) {
            
            enterTimePicker.setDate(enterDate, animated: false)
            leaveTimePicker.setDate(leaveDate, animated: false)
            leaveTimePicker.minimumDate = enterDate
        }
    }
    
    @objc private func enterTimeChanged() {
        let newEnterTime = enterTimePicker.date
        leaveTimePicker.minimumDate = newEnterTime
        
        if leaveTimePicker.date < newEnterTime {
            leaveTimePicker.setDate(newEnterTime, animated: true)
        }
    }
}

extension TimeCell {
    var enterTime: Date {
        return enterTimePicker.date
    }
    
    var exitTime: Date {
        return leaveTimePicker.date
    }
}
