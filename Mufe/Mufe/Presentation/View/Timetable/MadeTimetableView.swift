//
//  MadeTimetableView.swift
//  Mufe
//
//  Created by 신혜연 on 10/1/25.
//

import UIKit

import SnapKit
import Then

final class MadeTimetableView: UIView {
    
    // MARK: - Properties
    
    private var stageGroups: [ArtistInfo] = []
    
    // MARK: - UI Components
    
    private let summaryLabel = UILabel().then {
        $0.textColor = .gray40
        $0.customFont(.flg_SemiBold)
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MadeTimetableCell.self, forCellWithReuseIdentifier: MadeTimetableCell.identifier)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Setup & Layout
    
    private func setStyle() {
        backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubviews(summaryLabel, collectionView)
    }
    
    private func setLayout() {
        summaryLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(summaryLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(with stageGroups: [ArtistInfo]) {
        self.stageGroups = stageGroups

        let totalCount = stageGroups.flatMap { $0.artists }.count
        let totalMinutes = stageGroups.flatMap { $0.artists }.reduce(0) { $0 + $1.duration }
        summaryLabel.text = "총 \(totalCount)개, \(totalMinutes)분"

        collectionView.reloadData()
    }
}

// MARK: - Extensions (CollectionView)

extension MadeTimetableView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stageGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MadeTimetableCell.identifier, for: indexPath) as? MadeTimetableCell else {
            return UICollectionViewCell()
        }
        
        let stage = stageGroups[indexPath.item]
        cell.configure(stageNumber: stage.stage, stageName: stage.location, artists: stage.artists)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let artistCount = stageGroups[indexPath.item].artists.count

        let topPadding: CGFloat = 20
        let stageHeaderHeight: CGFloat = 24
        let spacingAfterHeader: CGFloat = 12
        let artistRowHeight: CGFloat = 54
        let spacingBetweenArtists: CGFloat = 16
        let bottomPadding: CGFloat = 20
        let artistsSectionHeight = (CGFloat(artistCount) * artistRowHeight) + (CGFloat(max(0, artistCount - 1)) * spacingBetweenArtists)
        let totalHeight = topPadding + stageHeaderHeight + spacingAfterHeader + artistsSectionHeight + bottomPadding

        let collectionViewWidth = collectionView.bounds.width
        let horizontalInsets: CGFloat = 16 * 2
        let cellWidth = collectionViewWidth - horizontalInsets

        return CGSize(width: cellWidth, height: totalHeight)
    }
}
