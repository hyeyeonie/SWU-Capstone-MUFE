//
//  DayInfoView.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

import SnapKit
import Then

protocol DayInfoViewDelegate: AnyObject {
    func didTapDay(dayNumber: Int, dayOfWeek: String, date: String)
}

final class DayInfoView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: DayInfoViewDelegate?
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
    
    // MARK: - UI Components
    
    private let daysContainerView = UIView().then {
        $0.backgroundColor = .gray70
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 8
    }
    
    private let daysLabel = UILabel().then {
        $0.textColor = .gray00
        $0.customFont(.fsm_SemiBold)
        $0.textAlignment = .center
    }
    
    private let dayOfWeekLabel = UILabel().then {
        $0.textColor = .gray20
        $0.customFont(.fsm_Medium)
    }
    
    private let eachDayLabel = UILabel().then {
        $0.textColor = .gray50
        $0.customFont(.fsm_Medium)
    }
    
    private let moreInfoButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        $0.tintColor = .gray20
    }
    
    private lazy var dayInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [daysContainerView, dayOfWeekLabel, eachDayLabel])
        stackView.axis = .horizontal
        stackView.spacing = 6
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        addSubviews(dayInfoStackView, moreInfoButton)
        daysContainerView.addSubview(daysLabel)
    }
    
    private func setupLayout() {
        daysLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 9, bottom: 4, right: 9))
        }
        
        dayInfoStackView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.height.equalTo(29)
        }
        
        moreInfoButton.snp.makeConstraints {
            $0.centerY.equalTo(dayInfoStackView)
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(20)
        }
    }
    
    // MARK: - Configure
    
    func configure(dayNumber: Int, dayOfWeek: String, date: String) {
        daysLabel.text = "\(dayNumber)일차"
        dayOfWeekLabel.text = dayOfWeek
        eachDayLabel.text = date
    }
    
    private func setDelegate() {
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapView() {
        guard let dayText = daysLabel.text else { return }
        let dayNumber = Int(dayText.replacingOccurrences(of: "일차", with: "")) ?? 0
        delegate?.didTapDay(dayNumber: dayNumber, dayOfWeek: dayOfWeekLabel.text ?? "", date: eachDayLabel.text ?? "")
    }
}
