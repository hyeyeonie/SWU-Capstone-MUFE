//
//  BeforeFestivalCell.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

final class BeforeFestivalCell: UICollectionViewCell {
    
    static let identifier = "BeforeFestivalCell"
    
    private let posterImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(resource: .beautifulMintLife) // posterImage
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    private let dDayContainerView = UIView().then {
        $0.backgroundColor = .primary50
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
    }
    
    private let dDayLabel = UILabel().then {
        $0.customFont(.fsm_SemiBold)
        $0.text = "D-29"
        $0.textColor = .gray00
    }
    
    private let festivalName = UILabel().then {
        $0.text = "사운드 플래닛 페스티벌 2025"
        $0.numberOfLines = 2
        $0.textColor = .gray00
        $0.customFont(.flg_Bold)
    }
    
    private let festivalTime = UILabel().then {
        $0.text = "2025.09.13 - 2025.09.14"
        $0.textColor = .gray50
        $0.customFont(.fsm_Medium)
    }
    
    private let festivalLocation = UILabel().then {
        $0.text = "파라다이스 시티"
        $0.textColor = .gray50
        $0.customFont(.fsm_Medium)
    }
    
    private lazy var festivalInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [festivalName, festivalTime, festivalLocation])
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private let ticketLine = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ticketLine2")
    }
    
    private let daysStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        setupDayInfoViewsForLayout()
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
        addSubviews(posterImage, dDayContainerView, festivalInfoStackView, ticketLine, daysStackView)
        dDayContainerView.addSubview(dDayLabel)
    }
    
    private func setLayout() {
        posterImage.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(140)
            $0.width.equalTo(105)
        }
        
        dDayContainerView.snp.makeConstraints {
            $0.top.equalTo(posterImage)
            $0.leading.equalTo(posterImage.snp.trailing).offset(12)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        festivalInfoStackView.snp.makeConstraints {
            $0.top.equalTo(dDayContainerView.snp.bottom).offset(10)
            $0.leading.equalTo(dDayContainerView)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        ticketLine.snp.makeConstraints{
            $0.top.equalTo(posterImage.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        daysStackView.snp.makeConstraints {
            $0.top.equalTo(ticketLine.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupDayInfoViewsForLayout() {
        let day1 = DayInfoView()
        day1.configure(dayNumber: 1, dayOfWeek: "토", date: "2025.09.13")
        
        let day2 = DayInfoView()
        day2.configure(dayNumber: 2, dayOfWeek: "일", date: "2025.09.14")
        
        daysStackView.addArrangedSubviews(day1, day2)
    }
}
