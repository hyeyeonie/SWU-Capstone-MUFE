//
//  BeforeFestivalView.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

import SnapKit
import Then

final class BeforeFestivalView: UIView {
    
    // MARK: - Properties
    
    
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "두근두근!\n페스티벌이 29일 남았어요." // 날짜 statea 변수 지정, 글자 나눠서 볼드처리
        $0.numberOfLines = 2
        $0.textColor = .gray20
        $0.customFont(.fxl_Medium)
    }
    
    private lazy var festivalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 343, height: 295) // 높이를 동적으로 변경
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BeforeFestivalCell.self, forCellWithReuseIdentifier: BeforeFestivalCell.identifier)
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubviews(titleLabel, festivalCollectionView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(74)
            $0.leading.equalToSuperview().inset(16)
        }
        
        festivalCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
    
    private func setDelegate() {
        festivalCollectionView.dataSource = self
    }
}

extension BeforeFestivalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BeforeFestivalCell.identifier,
            for: indexPath
        ) as? BeforeFestivalCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

#Preview {
    BeforeFestivalView()
}
