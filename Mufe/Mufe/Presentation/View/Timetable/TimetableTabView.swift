//
//  TimetableTabView.swift
//  Mufe
//
//  Created by 신혜연 on 10/15/25.
//

import UIKit

import SnapKit
import Then

final class TimetableTabView: UIView {
    
    private var festivalGroups: [String: [SavedFestival]] = [:]
    private var festivalList: [SavedFestival] = []
    private var festivalNames: [String] = []
    var didSelectFestival: ((String, [SavedFestival]) -> Void)?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(TimetableTabCell.self, forCellWithReuseIdentifier: TimetableTabCell.identifier)
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
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
    
    private func setStyle() {
        self.backgroundColor = .grayBg
    }
    
    private func setUI() {
        addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func configure(with festivalGroups: [String: [SavedFestival]], orderedKeys: [String]) {
        self.festivalGroups = festivalGroups
        self.festivalNames = orderedKeys
        collectionView.reloadData()
    }
}

extension TimetableTabView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return festivalNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimetableTabCell.identifier, for: indexPath) as? TimetableTabCell else {
            return UICollectionViewCell()
        }
        
        let festivalName = festivalNames[indexPath.item]
        if let festivalsForName = festivalGroups[festivalName] {
            cell.configure(with: festivalsForName)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 136)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let festivalName = festivalNames[indexPath.item]
        
        if let festivalsForName = festivalGroups[festivalName] {
            let sortedFestivals = festivalsForName.sorted(by: { $0.selectedDay < $1.selectedDay })
            didSelectFestival?(festivalName, sortedFestivals)
        }
    }
}
