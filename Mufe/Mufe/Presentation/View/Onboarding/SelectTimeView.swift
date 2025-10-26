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
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .grayBg
        cv.isScrollEnabled = false
        cv.showsVerticalScrollIndicator = false
        cv.register(TimeCell.self, forCellWithReuseIdentifier: TimeCell.identifier)
        return cv
    }()
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: collectionView.collectionViewLayout.collectionViewContentSize.height)
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
        addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setDelegate() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func updateItems(_ items: [DateItem]) {
        self.items = items
        collectionView.reloadData()
        
        DispatchQueue.main.async {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    func selectedTime(for day: String) -> (String, String)? {
        guard let index = items.firstIndex(where: { $0.day == day }),
              let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? TimeCell else {
            return nil
        }
        
        let formatter = DateFormatter.hourMinute
        let enterTime = formatter.string(from: cell.enterTime)
        let exitTime = formatter.string(from: cell.exitTime)
        return (enterTime, exitTime)
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

extension SelectTimeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 191)
    }
}

extension SelectTimeView {
    var itemsList: [DateItem] {
        return items
    }
}

extension DateFormatter {
    static let hourMinute: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}
