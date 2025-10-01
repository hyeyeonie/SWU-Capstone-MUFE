//
//  TimetableViewController.swift
//  Mufe
//
//  Created by 신혜연 on 10/1/25.
//

import UIKit
import SnapKit
import Then

final class TimetableViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "시간표"
        $0.customFont(.f2xl_Bold)
        $0.textColor = .gray00
        $0.textAlignment = .left
    }
    
    private let addButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.filled()
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: CustomUIFont.fsm_SemiBold.font,
            .foregroundColor: UIColor.gray00
        ]
        config.attributedTitle = AttributedString("추가하기", attributes: AttributeContainer(attrs))
        
        let plusImage = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .regular))
        config.image = plusImage
        config.imagePlacement = .leading
        config.imagePadding = 4
        
        config.baseBackgroundColor = .primary50
        config.cornerStyle = .capsule
        
        $0.configuration = config
        $0.clipsToBounds = true
    }
    
    private let emptyView = emptyFestivalView().then {
        $0.setContentText("페스티벌 시간표를 만들어볼까요?")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    // MARK: - Setting Methods
    
    private func setStyle() {
        view.backgroundColor = .grayBg
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUI() {
        view.addSubviews(emptyView, titleLabel, addButton)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    private func setAction() {
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
    }
    
    @objc private func didTapAddButton() {
        let onboardingVC = OnboardingViewController()
        
        let nav = UINavigationController(rootViewController: onboardingVC)
        nav.modalPresentationStyle = .fullScreen
        nav.setNavigationBarHidden(true, animated: false)
        
        self.present(nav, animated: true)
    }
}
