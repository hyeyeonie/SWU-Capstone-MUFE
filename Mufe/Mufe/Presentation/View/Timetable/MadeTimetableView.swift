//
//  MadeTimetableView.swift
//  Mufe
//
//  Created by 신혜연 on 10/1/25.
//

import UIKit

import SnapKit
import Then

final class MadeTimetableView: UIView {
    
    // MARK: - Properties
    
    private var startTime = "11:50"
    private var endTime = "12:20"
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 동적으로 생성
    private lazy var dayOneButton = createDayButton(title: "1일차", date: "9.13", isSelected: true)
    private lazy var dayTwoButton = createDayButton(title: "2일차", date: "9.14", isSelected: false)
    
    private let daySelectionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    private let summaryLabel = UILabel().then {
        $0.text = "총 5개, 270분"
        $0.textColor = .gray40
        $0.customFont(.flg_SemiBold)
    }
    
    // cell
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
        backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            stageNumber, stageName,
            contentContainerView
        )
        
        contentContainerView.addSubviews(
            artistImage, artistName,
            timeIcon, runningTime, duration
        )
        
        daySelectionStackView.addArrangedSubviews(dayOneButton, dayTwoButton)
    }
    
    private func setLayout() {
        
    }
    
    private func createDayButton(title: String, date: String, isSelected: Bool) -> UIButton {
        let button = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(
            string: "\(title)\n\(date)",
            attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
                .foregroundColor: isSelected ? UIColor.white : UIColor.gray
            ]
        )
        button.setAttributedTitle(attributedString, for: .normal)
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        button.backgroundColor = isSelected ? .orange : .darkGray
        button.layer.cornerRadius = 12
        return button
    }
}
