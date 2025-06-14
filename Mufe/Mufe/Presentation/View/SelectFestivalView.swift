//
//  SelectFestivalView.swift
//  Mufe
//
//  Created by 신혜연 on 5/28/25.
//

import UIKit

import SnapKit
import Then

final class SelectFestivalView: UIView {
    
    weak var delegate: FestivalSelectionDelegate?
    
    let festivals: [Festival] = DummyFestivalData.festivals
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .grayBg
        $0.isScrollEnabled = false
        $0.register(FestivalCell.self, forCellWithReuseIdentifier: FestivalCell.identifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            let cellHeight = 104
            let spacing = 24
            let itemCount = festivals.count
            let totalHeight = (cellHeight * itemCount) + (spacing * max(itemCount - 1, 0))
            $0.height.equalTo(totalHeight)
        }
    }
    
    private func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 104)
        return layout
    }
}

extension SelectFestivalView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return festivals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FestivalCell.identifier, for: indexPath) as? FestivalCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: festivals[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFestival = festivals[indexPath.item]
        delegate?.didSelectFestival(selectedFestival)
    }
}
