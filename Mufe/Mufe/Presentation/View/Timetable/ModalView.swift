//
//  ModalView.swift
//  Mufe
//
//  Created by 신혜연 on 10/13/25.
//

import UIKit

import SnapKit
import Then

final class ModalView: UIView {

    // MARK: - Properties
    
    // 뷰 컨트롤러와 통신하기 위한 클로저 (콜백)
    var onDenyButtonTapped: (() -> Void)?
    var onAcceptButtonTapped: (() -> Void)?

    // MARK: - UI Components
    
    // 반투명 배경
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.5)
    }

    // 메인 컨테이너
    private let modalContainerView = UIView().then {
        $0.backgroundColor = .gray80
        $0.layer.cornerRadius = 20
        $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    // 상단 핸들
    private let handleView = UIView().then {
        $0.backgroundColor = .gray20
        $0.layer.cornerRadius = 2
    }

    // 아이콘 이미지 (아무 이름으로 설정, 나중에 교체)
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(resource: .recomendModal)
        $0.contentMode = .scaleAspectFit
    }

    // 메인 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "뮤프가 딱 맞는 공연을 더 추가해드릴게요"
        $0.textColor = .gray00
        $0.textAlignment = .center
        $0.customFont(.fxl_Bold)
    }

    // 서브 타이틀
    private let subtitleLabel = UILabel().then {
        $0.text = "남은 시간 취향에 맞는 아티스트 공연을\n즐겨보는 건 어때요?"
        $0.textColor = .gray40
        $0.numberOfLines = 2
        $0.customFont(.fmd_Medium)
        $0.textAlignment = .center
    }

    // "괜찮아요" 버튼
    private let denyButton = UIButton(type: .system).then {
        $0.setTitle("괜찮아요", for: .normal)
        $0.backgroundColor = .gray90
        $0.setTitleColor(.gray60, for: .normal)
        $0.layer.cornerRadius = 16
        $0.titleLabel?.customFont(.flg_SemiBold)
    }

    // "추천받기" 버튼
    private let acceptButton = UIButton(type: .system).then {
        $0.setTitle("추천받기", for: .normal)
        $0.backgroundColor = .primary50
        $0.setTitleColor(.gray00, for: .normal)
        $0.layer.cornerRadius = 16
        $0.titleLabel?.customFont(.flg_SemiBold)
    }
    
    // 버튼 두 개를 담을 스택뷰
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [denyButton, acceptButton]).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
        setActions()
        print(subtitleLabel.textAlignment.rawValue)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setUI() {
        addSubviews(backgroundView, modalContainerView)
        modalContainerView.addSubviews(handleView, iconImageView, titleLabel, subtitleLabel, buttonStackView)
    }

    private func setLayout() {
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        modalContainerView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(354)
        }

        handleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(4)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.equalTo(handleView.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(88)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(36)
            $0.height.equalTo(52)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func setActions() {
        denyButton.addTarget(self, action: #selector(didTapDenyButton), for: .touchUpInside)
        acceptButton.addTarget(self, action: #selector(didTapAcceptButton), for: .touchUpInside)
    }

    // MARK: - Action Handlers
    
    @objc private func didTapDenyButton() {
        onDenyButtonTapped?()
    }
    
    @objc private func didTapAcceptButton() {
        onAcceptButtonTapped?()
    }
}

#Preview {
    ModalView()
}
