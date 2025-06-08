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
    
    let festivals: [Festival] = [
        Festival(imageName: "fstImg", name: "2025 뷰티풀민트라이프", startDate: "2025.01.03", endDate: "2025.01.06", location: "올림픽공원"),
        Festival(imageName: "fstImg", name: "2025 썸머페스트", startDate: "2025.06.15", endDate: "2025.06.18", location: "한강공원"),
        Festival(imageName: "fstImg", name: "2025 록앤롤 나이트", startDate: "2025.08.02", endDate: "2025.08.04", location: "서울숲"),
        Festival(imageName: "fstImg", name: "2025 록앤롤 나이트", startDate: "2025.08.02", endDate: "2025.08.04", location: "서울숲"),
        Festival(imageName: "fstImg", name: "2025 록앤롤 나이트", startDate: "2025.08.02", endDate: "2025.08.04", location: "서울숲"),
        Festival(imageName: "fstImg", name: "2025 록앤롤 나이트", startDate: "2025.08.02", endDate: "2025.08.04", location: "서울숲")
    ]
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .black
        $0.isScrollEnabled = false
        $0.register(FestivalCollectionViewCell.self, forCellWithReuseIdentifier: FestivalCollectionViewCell.identifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
        
        reloadAndResize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadAndResize() {
        collectionView.reloadData()
        DispatchQueue.main.async {
            let contentHeight = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.snp.remakeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(contentHeight)
            }
        }
    }
    
    private func setUI() {
        addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FestivalCollectionViewCell.identifier, for: indexPath) as? FestivalCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: festivals[indexPath.item])
        return cell
    }
}
