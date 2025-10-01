//
//  DdayFestivalView.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

import SnapKit
import Then

final class DdayFestivalView: UIView {
    
    // MARK: - Properties
    
    private var festivalTimes: [(artist: ArtistSchedule, stage: ArtistInfo)] = []
    
    // MARK: - UI Components
    
    private lazy var festivalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 343, height: 139)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DdayFestivalCell.self, forCellWithReuseIdentifier: DdayFestivalCell.identifier)
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
        festivalCollectionView.contentInset.bottom = 33
    }
    
    func updateFestivalTimes(_ times: [(artist: ArtistSchedule, stage: ArtistInfo)]) {
        DispatchQueue.main.async {
            self.festivalTimes = times
            self.festivalCollectionView.reloadData()
        }
    }
}

extension DdayFestivalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return festivalTimes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DdayFestivalCell.identifier,
            for: indexPath) as? DdayFestivalCell else {
            return UICollectionViewCell()
        }

        let (artist, stage) = festivalTimes[indexPath.item]
        cell.configure(with: artist, stage: stage)

        return cell
    }
}

#Preview {
    DdayFestivalView()
}
