//
//  AfterFestivalView.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

import SnapKit
import Then

final class AfterFestivalView: UIView {
    
    // MARK: - Properties
    
    private let festivalTimes: [(start: String, end: String)] = [
        ("17:50", "18:20"),
        ("18:30", "19:00")
    ]
    
    // MARK: - UI Components
    
    private lazy var festivalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 343, height: 139)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AfterFestivalCell.self, forCellWithReuseIdentifier: AfterFestivalCell.identifier)
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
        addSubviews(festivalCollectionView)
    }
    
    private func setLayout() {
        festivalCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        festivalCollectionView.dataSource = self
    }
}

extension AfterFestivalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AfterFestivalCell.identifier,
            for: indexPath
        ) as? AfterFestivalCell else {
            return UICollectionViewCell()
        }
        
        let time = festivalTimes[indexPath.item]
        cell.configure(start: time.start, end: time.end)
        
        return cell
    }
}

#Preview {
    AfterFestivalView()
}
