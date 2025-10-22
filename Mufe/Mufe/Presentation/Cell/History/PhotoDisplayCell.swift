//
//  PhotoDisplayCell.swift
//  Mufe
//
//  Created by 신혜연 on 10/20/25.
//

import UIKit

import SnapKit
import Then

final class PhotoDisplayCell: UICollectionViewCell {
    static let identifier = "PhotoDisplayCell"
    var didTapRemove: (() -> Void)?

    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.backgroundColor = .gray70
        $0.isUserInteractionEnabled = false
    }

    lazy var removeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .gray50
        $0.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = false
        self.clipsToBounds = false
        contentView.addSubviews(imageView, removeButton)

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        removeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerX.equalTo(imageView.snp.trailing)
            $0.centerY.equalTo(imageView.snp.top)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(image: UIImage) {
        imageView.image = image
    }

    @objc private func removeButtonTapped() {
        didTapRemove?()
    }
}

extension PhotoDisplayCell {
     var deleteButton: UIButton {
         return removeButton
     }
}

