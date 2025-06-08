//
//  SelectTimeView.swift
//  Mufe
//
//  Created by 신혜연 on 6/1/25.
//

import UIKit

import SnapKit
import Then

final class SelectTimeView: UIView {
    
    private var items: [DateItem] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 343, height: 191)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.showsVerticalScrollIndicator = false
        cv.register(TimeCell.self, forCellWithReuseIdentifier: TimeCell.identifier)
        return cv
    }()
    
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
        addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setDelegate() {
        collectionView.dataSource = self
    }
    
    func updateItems(_ items: [DateItem]) {
        self.items = items
        collectionView.reloadData()
    }
}

extension SelectTimeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimeCell.identifier, for: indexPath) as? TimeCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}
