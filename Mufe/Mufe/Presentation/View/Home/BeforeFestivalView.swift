//
//  BeforeFestivalView.swift
//  Mufe
//
//  Created by 신혜연 on 8/30/25.
//

import UIKit

import SnapKit
import Then

final class BeforeFestivalView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: DateSelectionDelegate?
    
    private var savedDays: [SavedFestival] = [] {
        didSet { festivalCollectionView.reloadData() }
    }
    
    func setFestivals(_ festivals: [SavedFestival]) {
        self.savedDays = festivals.sorted { $0.selectedDay < $1.selectedDay }
    }
    
    // MARK: - UI Components
    private lazy var festivalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 343, height: 295) // 높이를 동적으로 변경
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(BeforeFestivalCell.self, forCellWithReuseIdentifier: BeforeFestivalCell.identifier)
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
        festivalCollectionView.delegate = self
    }
}

extension BeforeFestivalView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard !savedDays.isEmpty else {
            // 데이터가 없을 때의 기본 크기
            return CGSize(width: 343, height: 295)
        }
        
        let topInset: CGFloat = 20
        let posterHeight: CGFloat = 140
        let posterBottomOffset: CGFloat = 8
        let ticketLineHeight: CGFloat = 24
        let daysStackSpacing: CGFloat = 8
        let dayInfoHeight: CGFloat = 29
        let dayInfoSpacing: CGFloat = 16
        
        // 이제 이 상수들을 사용해서 높이를 정상적으로 계산할 수 있습니다.
        let totalDayInfoHeight = CGFloat(savedDays.count) * dayInfoHeight +
                                 CGFloat(max(savedDays.count - 1, 0)) * dayInfoSpacing
        
        let totalHeight = topInset + posterHeight + posterBottomOffset +
                          ticketLineHeight + daysStackSpacing + totalDayInfoHeight + 20
        
        return CGSize(width: 343, height: totalHeight)
    }
}

extension BeforeFestivalView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedDays.isEmpty ? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BeforeFestivalCell.identifier,
            for: indexPath
        ) as? BeforeFestivalCell,
              !savedDays.isEmpty else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: savedDays)
        cell.delegate = delegate
        return cell
    }
}

extension BeforeFestivalView: DateSelectionDelegate {
    func didSelectDate(_ dateItem: DateItem) {
        delegate?.didSelectDate(dateItem)
    }
}

#Preview {
    BeforeFestivalView()
}
