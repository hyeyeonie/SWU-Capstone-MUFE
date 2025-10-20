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
    var didTapRemove: (() -> Void)? // 삭제 버튼 탭 액션 클로저

    // 사진 이미지 뷰
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
        $0.backgroundColor = .gray70
        $0.isUserInteractionEnabled = false
    }

    // 'x' 삭제 버튼
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

    // 이미지 설정 함수
    func configure(image: UIImage) {
        imageView.image = image
    }

    // 삭제 버튼 탭 시 클로저 호출
    @objc private func removeButtonTapped() {
        didTapRemove?()
    }
}

extension PhotoDisplayCell {
    // 만약 removeButton이 private lazy var 라면, 아래와 같이 getter 추가
     var deleteButton: UIButton { // 접근 가능한 이름으로 변경 (예: deleteButton)
         return removeButton
     }
    // 만약 removeButton이 internal 이나 public 이라면 이 extension 불필요
}

