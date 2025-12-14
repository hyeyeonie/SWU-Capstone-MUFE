//
//  EditTimetableView.swift
//  Mufe
//
//  Created by 신혜연 on 11/19/25.
//

import UIKit

import SnapKit
import Then

final class EditTimetableView: UIView {

    private(set) var closeButton = UIButton(type: .custom).then {
        $0.setImage(UIImage(resource: .close), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    private let dayLabel = UILabel().then {
        $0.customFont(.flg_SemiBold)
        $0.textColor = .gray00
    }
    
    private(set) var completeButton = UIButton(type: .custom).then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .primary50
        $0.titleLabel?.customFont(.fsm_SemiBold)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
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
    
    func configure(dayString: String) {
        dayLabel.text = dayString
    }
    
    private func setStyle() {
        backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubviews(closeButton, dayLabel, completeButton)
    }
    
    private func setLayout() {
        closeButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(70)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
        
        dayLabel.snp.makeConstraints{
            $0.centerY.equalTo(closeButton)
            $0.centerX.equalToSuperview()
        }
        
        completeButton.snp.makeConstraints{
            $0.centerY.equalTo(closeButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(48)
            $0.height.equalTo(25)
        }
    }
}

#Preview {
    EditTimetableView()
}
