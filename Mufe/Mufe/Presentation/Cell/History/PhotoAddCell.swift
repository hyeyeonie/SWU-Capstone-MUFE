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
    var didTapAdd: (() -> Void)?
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    var isAddEnabled: Bool = true {
        didSet {
            plusIconImageView.tintColor = isAddEnabled ? .gray40 : .gray70
            countLabel.textColor = isAddEnabled ? .gray40 : .gray70
            contentView.layer.borderColor = isAddEnabled ? UIColor.gray50.cgColor : UIColor.gray70.cgColor
        }
    }
    
    private let plusIconImageView = UIImageView().then {
        let image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .regular))
        $0.image = image
        $0.tintColor = .gray40
        $0.contentMode = .scaleAspectFit
    }

    private let countLabel = UILabel().then {
        $0.customFont(.fsm_Regular)
        $0.textColor = .gray40
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .gray90
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.gray50.cgColor
        contentView.layer.borderWidth = 1

        contentView.addSubviews(plusIconImageView, countLabel)

        plusIconImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(18)
            $0.size.equalTo(24)
        }
        countLabel.snp.makeConstraints {
            $0.top.equalTo(plusIconImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(countText: String) {
        countLabel.text = countText
    }
    
    private func setupTapGesture() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        contentView.addGestureRecognizer(tapGestureRecognizer)
        contentView.isUserInteractionEnabled = true
    }
    
    @objc private func cellTapped() {
        if isAddEnabled {
            print("PhotoAddCell Tapped!")
            didTapAdd?()
        } else {
            print("PhotoAddCell Tapped, but disabled.")
        }
    }
}
