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
    private var dates: [DateItem] = []
    
    private let ticketCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 343, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .grayBg
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
    
    func configure(with festival: Festival) {
        self.dates = generateDateItems(from: festival)
        ticketCollectionView.reloadData()
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
    
    private func generateDateItems(from festival: Festival) -> [DateItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        guard let start = formatter.date(from: festival.startDate),
              let end = formatter.date(from: festival.endDate) else {
            return []
        }
        
        var result: [DateItem] = []
        var current = start
        var index = 1
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "M월 d일 EEEE"
        
        while current <= end {
            let dateString = outputFormatter.string(from: current)
            result.append(DateItem(day: "\(index)일차", date: dateString))
            
            index += 1
            guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: current) else { break }
            current = nextDay
        }
        
        return result
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
