//
//  MadeTimetableEmptyView.swift
//  Mufe
//
//  Created by 신혜연 on 10/2/25.
//

import UIKit

import SnapKit
import Then

final class MadeTimetableEmptyView: UIView {
    
    var onRegisterButtonTapped: (() -> Void)?
    
    private let emptyView = UIImageView().then {
        $0.image = UIImage(resource: .mufeEmpty)
        $0.contentMode = .scaleAspectFit
    }
    
    private let contentLabel = UILabel().then {
        $0.customFont(.fxl_Medium)
        $0.textColor = .gray40
        $0.text = "생성된 타임테이블이 없어요.\n새로 만들어봐요!"
        $0.textAlignment = .center
        $0.numberOfLines = 2
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
    
    private func setStyle() {
        backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubviews(emptyView, contentLabel)
    }
    
    private func setLayout() {
        emptyView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(106)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(160)
        }
        
        contentLabel.snp.makeConstraints{
            $0.top.equalTo(emptyView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
}

#Preview {
    MadeTimetableEmptyView()
}
