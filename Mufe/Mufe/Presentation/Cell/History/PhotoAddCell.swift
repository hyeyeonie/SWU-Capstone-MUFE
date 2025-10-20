//
//  PhotoAddCell.swift
//  Mufe
//
//  Created by 신혜연 on 10/20/25.
//

import UIKit

import SnapKit
import Then

final class PhotoAddCell: UICollectionViewCell {
    
    static let identifier = "PhotoAddCell"
    var didTapAdd: (() -> Void)? // 추가 버튼 탭 액션 클로저
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    var isAddEnabled: Bool = true {
        didSet {
            // ⭐️ 버튼 대신 아이콘/텍스트 색상 변경 (예시)
            plusIconImageView.tintColor = isAddEnabled ? .gray40 : .gray70 // 아이콘 색상 변경
            countLabel.textColor = isAddEnabled ? .gray40 : .gray70 // 텍스트 색상 변경
            contentView.layer.borderColor = isAddEnabled ? UIColor.gray50.cgColor : UIColor.gray70.cgColor // 테두리 색상 변경
            // ⭐️ 탭 제스처 자체를 비활성화할 수도 있음
            // tapGestureRecognizer.isEnabled = isAddEnabled
        }
    }
    
    // ⭐️ '+' 아이콘을 UIImageView로 변경 (버튼 제거)
    private let plusIconImageView = UIImageView().then {
        let image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)) // 아이콘 크기/굵기 조절
        $0.image = image
        $0.tintColor = .gray40
        $0.contentMode = .scaleAspectFit
    }

    // '0/5' 개수 표시 레이블
    private let countLabel = UILabel().then {
        $0.customFont(.fsm_Regular) // 커스텀 폰트 가정
        $0.textColor = .gray40
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        // 셀 스타일 설정
        contentView.backgroundColor = .gray90 // 배경색 (가정)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.gray50.cgColor // 테두리 색 (가정)
        contentView.layer.borderWidth = 1

        contentView.addSubviews(plusIconImageView, countLabel)

        // 레이아웃 설정
        plusIconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            // 위쪽에 약간 여백을 주고 배치
            $0.top.equalToSuperview().offset(18) // (80 - (아이콘 크기 + 레이블 높이 + 간격)) / 2 정도
            $0.size.equalTo(24) // 아이콘 크기
        }
        countLabel.snp.makeConstraints {
            $0.top.equalTo(plusIconImageView.snp.bottom).offset(4) // 버튼과 레이블 간 간격
            $0.centerX.equalToSuperview()
        }
        
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 개수 텍스트 설정 함수
    func configure(countText: String) {
        countLabel.text = countText
    }
    
    private func setupTapGesture() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        contentView.isUserInteractionEnabled = true // contentView가 터치 받도록 설정
    }
    
    // ⭐️ 셀 탭 시 호출될 액션 함수
    @objc private func cellTapped() {
        // isAddEnabled 상태일 때만 didTapAdd 클로저 호출
        if isAddEnabled {
            print("PhotoAddCell Tapped!") // 디버깅 로그
            didTapAdd?()
        } else {
            print("PhotoAddCell Tapped, but disabled.") // 디버깅 로그
        }
    }
}
