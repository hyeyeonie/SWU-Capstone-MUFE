//
//  EmptyFestivalView.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

protocol EmptyFestivalViewDelegate: AnyObject {
    func didTapRegisterFestButton()
}

final class EmptyFestivalView: UIView {
    
    weak var delegate: EmptyFestivalViewDelegate?
    
    // MARK: - UI Components

    private let mufeImageView = UIImageView().then {
        $0.image = UIImage(named: "mufeMain")
        $0.contentMode = .scaleAspectFit
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "어떤 페스티벌에 참여하세요?"
        $0.textColor = .gray40
        $0.customFont(.fmd_Medium)
    }
    
    private let registerFestButton = UIButton().then {
        $0.setTitle("페스티벌 등록하기", for: .normal)
        $0.titleLabel?.customFont(.flg_SemiBold)
        $0.layer.cornerRadius = 12
        $0.setTitleColor(.gray80, for: .normal)
        $0.backgroundColor = .gray05
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubviews(mufeImageView,
                    contentLabel,
                    registerFestButton)
    }
    
    private func setLayout() {
        mufeImageView.snp.makeConstraints {
            $0.size.equalTo(160)
            $0.top.equalToSuperview().inset(280)
            $0.centerX.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(mufeImageView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
        
        registerFestButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(158)
            $0.height.equalTo(43)
        }
    }
    
    // MARK: - Action
    
    private func setAction() {
        registerFestButton.addTarget(self, action: #selector(didTapRegisterFestButton), for: .touchUpInside)
    }
    
    @objc func didTapRegisterFestButton() {
        delegate?.didTapRegisterFestButton()
    }
}
