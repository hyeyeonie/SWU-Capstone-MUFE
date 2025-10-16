//
//  TimetableTabCell.swift
//  Mufe
//
//  Created by 신혜연 on 10/15/25.
//

import UIKit

final class TimetableTabCell: UICollectionViewCell {
    
    static let identifier = "TimetableTabCell"
    
    private let posterImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }
    
    private let fstNameLabel = UILabel().then {
        $0.customFont(.flg_Bold)
        $0.textColor = .gray10
        $0.numberOfLines = 2
    }
    
    private let fstDateLabel = UILabel().then {
        $0.customFont(.fsm_Medium)
        $0.textColor = .gray20
    }
    private let fstLocationLabel = UILabel().then {
        $0.customFont(.fsm_Medium)
        $0.textColor = .gray40
    }
    
    private let dayTagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.distribution = .fill
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = .gray90
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with festivals: [SavedFestival]) {
        // 배열이 비어있으면 아무것도 하지 않습니다.
        guard let firstFestival = festivals.first else { return }
        
        // 1. 기본 정보는 배열의 첫 번째 객체를 기준으로 설정합니다.
        posterImageView.image = UIImage(named: firstFestival.festivalImageName)
        fstNameLabel.text = firstFestival.festivalName
        fstDateLabel.text = "\(firstFestival.startDate) - \(firstFestival.endDate)"
        fstLocationLabel.text = firstFestival.location

        // 2. ⭐️ Day Tag를 모두 표시하도록 로직을 변경합니다.
        dayTagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 모든 저장된 페스티벌 객체에서 'selectedDay'를 가져와 정렬합니다.
        let dayStrings = festivals.map { $0.selectedDay }.sorted()
        
        for dayString in dayStrings {
            // "1일차" 같은 문자열에서 숫자 "1"만 안전하게 추출합니다.
            if let dayNumber = Int(dayString.filter { "0"..."9" ~= $0 }) {
                let tag = Daytag()
                tag.configure(day: dayNumber)
                dayTagStackView.addArrangedSubview(tag)
            }
        }
    }
    
    private func setUI() {
        contentView.addSubviews(
            posterImageView,
            fstNameLabel,
            fstDateLabel,
            fstLocationLabel,
            dayTagStackView,
            dividerView
        )
    }
    
    private func setLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(78)
            $0.height.equalTo(104)
        }
        
        fstNameLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
        }
        
        fstDateLabel.snp.makeConstraints {
            $0.top.equalTo(fstNameLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(fstNameLabel)
        }
        
        fstLocationLabel.snp.makeConstraints {
            $0.top.equalTo(fstDateLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalTo(fstNameLabel)
        }
        
        dayTagStackView.snp.makeConstraints {
            $0.top.equalTo(fstLocationLabel.snp.bottom).offset(15)
            $0.leading.equalTo(fstNameLabel)
            $0.trailing.lessThanOrEqualToSuperview().inset(16)
        }
        
        dividerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}
