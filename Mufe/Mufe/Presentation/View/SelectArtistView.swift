//
//  SelectArtistView.swift
//  Mufe
//
//  Created by 신혜연 on 6/4/25.
//

import UIKit

import SnapKit
import Then

final class SelectArtistView: UIView {
    
    private var artists: [ArtistInfo] = []
    private var collectionViewHeightConstraint: Constraint?
    private var selectedArtists: Set<String> = []
    
    private let dayLabel = UILabel().then {
        $0.customFont(.fxl_Bold)
        $0.textColor = .gray05
    }
    
    private let dateLabel = UILabel().then {
        $0.customFont(.fmd_Medium)
        $0.textColor = .gray40
    }
    
    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
        
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing: CGFloat = 16 * 2 + 12 * 2
        let itemWidth = screenWidth - 32
        
        layout.itemSize = CGSize(width: itemWidth, height: 160)
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .grayBg
        collectionView.isScrollEnabled = false
        collectionView.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.identifier)
        return collectionView
    }()
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: dayLabel.intrinsicContentSize.height + 20 + (collectionViewHeightConstraint?.layoutConstraints.first?.constant ?? 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubviews(dayLabel, dateLabel, collectionView)
    }
    
    private func setLayout() {
        dayLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dayLabel)
            $0.leading.equalTo(dayLabel.snp.trailing).offset(8)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dayLabel.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
            collectionViewHeightConstraint = $0.height.equalTo(0).constraint
        }
    }
    
    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configure(day: String, date: String) {
        dayLabel.text = day
        dateLabel.text = date
    }
    
    func updateArtists(_ artists: [ArtistInfo]) {
        self.artists = artists
        collectionView.reloadData()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.layoutIfNeeded()
            
            let height = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeightConstraint?.update(offset: height)
            
            self.invalidateIntrinsicContentSize()
            self.layoutIfNeeded()
        }
    }
    
    func getSelectedArtistNames() -> [String] {
        return Array(selectedArtists)
    }
}

extension SelectArtistView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.identifier, for: indexPath) as? ArtistCell else {
            return UICollectionViewCell()
        }
        
        let artistInfo = artists[indexPath.item]
        cell.configure(stage: artistInfo.stage,
                       location: artistInfo.location,
                       artists: artistInfo.artists)
        cell.delegate = self
        return cell
    }
}

extension SelectArtistView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("선택된 아티스트: \(artists[indexPath.item])")
    }
}

extension SelectArtistView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let artistInfo = artists[indexPath.item]
        let rowCount = ceil(Double(artistInfo.artists.count) / 3.0)

        let rowHeight: CGFloat = 109
        let verticalSpacing: CGFloat = 24
        let artistTopPadding: CGFloat = 63
        let bottomPadding: CGFloat = 20
        
        let totalHeight = artistTopPadding
                       + (rowHeight * CGFloat(rowCount))
                       + (verticalSpacing * max(CGFloat(rowCount - 1), 0))
                       + bottomPadding
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth - 32
        
        return CGSize(width: itemWidth, height: totalHeight)
    }
}

extension SelectArtistView: ArtistCellDelegate {
    func didToggleArtistSelection(name: String, isSelected: Bool) {
        if isSelected {
            selectedArtists.insert(name)
        } else {
            selectedArtists.remove(name)
        }
    }
}
