//
//  HomeViewController.swift
//  Mufe
//
//  Created by 신혜연 on 8/14/25.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: UIViewController {
    
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
        $0.titleLabel?.customFont(.flg_Bold)
        $0.layer.cornerRadius = 12
        $0.setTitleColor(.gray00, for: .normal)
        $0.backgroundColor = .gray80
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        view.backgroundColor = .grayBg
    }
    
    private func setUI() {
        view.addSubviews(mufeImageView,
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
            $0.top.equalTo(contentLabel.snp.bottom).offset(7)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(159)
            $0.height.equalTo(38)
        }
    }
    
    // MARK: - Action
    
    private func setAction() {
        registerFestButton.addTarget(self, action: #selector(didTapRegisterFestButton), for: .touchUpInside)
    }

    @objc private func didTapRegisterFestButton() {
        let registerVC = OnboardingViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

#Preview {
    HomeViewController()
}
