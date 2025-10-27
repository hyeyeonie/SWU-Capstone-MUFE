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
    
    private var timetables: [SavedTimetable] = []
    private let dummyCell = DdayFestivalCell(frame: .zero)
    
    // MARK: - UI Components
    
    private lazy var festivalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
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
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        festivalCollectionView.dataSource = self
        festivalCollectionView.delegate = self
        festivalCollectionView.contentInset.bottom = 33
    }
    
    func updateFestivalTimes(_ times: [SavedTimetable]) {
        DispatchQueue.main.async {
            self.timetables = times
            self.festivalCollectionView.reloadData()
        }
    }
}

extension DdayFestivalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timetables.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DdayFestivalCell.identifier,
            for: indexPath) as? DdayFestivalCell else {
            return UICollectionViewCell()
        }

        let timetable = timetables[indexPath.item]
        cell.configure(with: timetable)

        return cell
    }
}

extension DdayFestivalView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let targetWidth = collectionView.bounds.width
        let timetable = timetables[indexPath.item]
        dummyCell.configure(with: timetable)
        
        let calculatedSize = dummyCell.contentView.systemLayoutSizeFitting(
            CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return calculatedSize
    }
}

#Preview {
    DdayFestivalView()
}
