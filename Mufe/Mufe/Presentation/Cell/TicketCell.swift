//
//  TicketCell.swift
//  Mufe
//
//  Created by 신혜연 on 5/29/25.
//

import UIKit

final class TicketCell: UICollectionViewCell {
    
    static let identifier = "TicketCell"
    
    private let ticketButton = UIButton().then {
        $0.backgroundColor = .gray80
        $0.layer.cornerRadius = 16
        $0.isUserInteractionEnabled = false
        $0.clipsToBounds = true
    }
    
    private let dayLabel = UILabel().then {
        $0.customFont(.flg_Bold)
        $0.textColor = .gray00
    }
    
    private let dateLabel = UILabel().then {
        $0.customFont(.fsm_Medium)
        $0.textColor = .gray20
    }
    
    private let ticketLine = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "ticketLine")
    }
    
    private let plusLabel = UILabel().then {
        // 만약 이미 타임테이블을 만들었으면 "이미만들었어요"
        $0.text = "+"
        $0.font = .systemFont(ofSize: 28)
        $0.textColor = .lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubviews(ticketButton)
        ticketButton.addSubviews(dayLabel, dateLabel, ticketLine, plusLabel)
    }
    
    private func setLayout() {
        ticketButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(343)
            $0.height.equalTo(80)
        }
        
        dayLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(dayLabel)
            $0.top.equalTo(dayLabel.snp.bottom).offset(4)
        }
        
        ticketLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(128)
            $0.verticalEdges.equalToSuperview()
        }
        
        plusLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(30)
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    
    func setDate(day: String, date: String) {
        dayLabel.text = day
        dateLabel.text = date
    }
}
