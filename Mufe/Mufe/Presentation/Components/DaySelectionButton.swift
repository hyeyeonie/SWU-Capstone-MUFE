//
//  DaySelectionButton.swift
//  Mufe
//
//  Created by 신혜연 on 10/2/25.
//

import UIKit

import SnapKit
import Then

struct DayItem {
    let title: String
    let date: String
}

final class DaySelectionButton: UIControl {
    
    override var isSelected: Bool {
        didSet {
            updateSelectionState()
        }
    }
    
    private(set) var dayTitle = UILabel().then {
        $0.customFont(.fmd_Medium)
        $0.text = "1일차"
        $0.textColor = .gray20
    }
    
    private(set) var dayText = UILabel().then {
        $0.customFont(.fsm_Medium)
        $0.text = "6.12"
        $0.textColor = .gray50
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        updateSelectionState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .gray90
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }
    
    private func setUI() {
        addSubviews(dayTitle, dayText)
    }
    
    private func setLayout() {
        snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(80)
        }
        
        dayTitle.snp.makeConstraints{
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
        
        dayText.snp.makeConstraints {
            $0.top.equalTo(dayTitle.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func updateSelectionState() {
        backgroundColor = isSelected ? .primary50 : .gray90
        dayTitle.textColor = isSelected ? .gray00 : .gray20
        dayText.textColor = isSelected ? .primary00 : .gray50
        if isSelected {
            dayTitle.customFont(.fmd_Bold)
        } else {
            dayTitle.customFont(.fmd_Medium)
        }
    }
    
    // MARK: - Public Methods
    
    func configure(with item: DayItem) {
        dayTitle.text = item.title
        
        let formattedDate = item.date
            .split(separator: ".")
            .compactMap { Int($0) }
            .map { String($0) }
            .joined(separator: ".")
        
        dayText.text = formattedDate
    }
}
