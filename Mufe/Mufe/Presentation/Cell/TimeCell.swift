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
        $0.font = .boldSystemFont(ofSize: 20)
        $0.textColor = .white
    }
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .lightGray
    }
    
    private let ticketLine = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ticketLine2")
    }
    
    private let enterTitle = UILabel().then {
        $0.text = "입장시간"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let leaveTitle = UILabel().then {
        $0.text = "퇴장시간"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let enterTimePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .inline
        $0.tintColor = .white
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    private let leaveTimePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .inline
        $0.tintColor = .white
        $0.locale = Locale(identifier: "ko_KR")
    }
    
    private let wave = UILabel().then {
        $0.text = "~"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 32, weight: .regular)
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
    
    func configure(with item: DateItem) {
        dayLabel.text = item.day
        dateLabel.text = item.date
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        
        if let enterDate = formatter.date(from: item.enterTime) {
            enterTimePicker.setDate(enterDate, animated: false)
        }
        
        if let leaveDate = formatter.date(from: item.leaveTime) {
            leaveTimePicker.setDate(leaveDate, animated: false)
        }
    }
    
    private func setStyle() {
        backgroundColor = .darkGray
        layer.cornerRadius = 16
    }
    
    private func setUI() {
        addSubviews(dayLabel, dateLabel, ticketLine,
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
            $0.width.equalTo(363)
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
            $0.bottom.equalToSuperview().inset(56)
            $0.centerX.equalToSuperview()
        }
        
        leaveTimePicker.snp.makeConstraints {
            $0.centerY.equalTo(enterTimePicker)
            $0.centerX.equalTo(leaveTitle)
        }
    }
}
