//
//  SelectDateView.swift
//  Mufe
//
//  Created by 신혜연 on 5/29/25.
//

import UIKit

import SnapKit
import Then

protocol SelectDateViewDelegate: AnyObject {
    func didSelectDate(_ dateItem: DateItem)
}

final class SelectDateView: UIView {
    
    weak var delegate: SelectDateViewDelegate?
    
    private let dates: [DateItem] = [
        DateItem(day: "1일차", date: "1월 7일 토요일"),
        DateItem(day: "2일차", date: "1월 8일 일요일"),
        DateItem(day: "3일차", date: "1월 9일 월요일")
    ]
    
    private let ticketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 343, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(TicketCell.self, forCellWithReuseIdentifier: TicketCell.identifier)
        return collectionView
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
        addSubview(ticketCollectionView)
    }
    
    private func setLayout() {
        ticketCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        ticketCollectionView.dataSource = self
        ticketCollectionView.delegate = self
    }
}

extension SelectDateView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TicketCell.identifier,
            for: indexPath
        ) as? TicketCell else {
            return UICollectionViewCell()
        }
        
        let item = dates[indexPath.item]
        cell.setDate(day: item.day, date: item.date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = dates[indexPath.item]
        delegate?.didSelectDate(selectedItem)
    }
}
