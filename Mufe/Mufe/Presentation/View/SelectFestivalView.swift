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
    
    let festivals: [Festival] = [
        Festival(
            imageName: "fstImg",
            name: "2025 뷰티풀민트라이프",
            startDate: "2025.01.03",
            endDate: "2025.01.06",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "잔나비", image: UIImage(named: "artistImg"), startTime: "15:00", endTime: "16:30"),
                        ArtistSchedule(name: "혁오", image: UIImage(named: "artistImg"), startTime: "17:00", endTime: "18:00")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "SK핸드볼경기장", artists: [
                        ArtistSchedule(name: "10cm", image: UIImage(named: "artistImg"), startTime: "14:00", endTime: "15:00"),
                        ArtistSchedule(name: "볼빨간사춘기", image: UIImage(named: "artistImg"), startTime: "15:30", endTime: "16:30")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "적재", image: UIImage(named: "artistImg"), startTime: "13:00", endTime: "14:00"),
                        ArtistSchedule(name: "NCT", image: UIImage(named: "artistImg"), startTime: "18:00", endTime: "19:30")
                    ])
                ]
            ]
        ),
        Festival(
            imageName: "fstImg",
            name: "2025 뷰티풀민트라이프",
            startDate: "2025.01.03",
            endDate: "2025.01.06",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "잔나비", image: UIImage(named: "artistImg"), startTime: "15:00", endTime: "16:30"),
                        ArtistSchedule(name: "혁오", image: UIImage(named: "artistImg"), startTime: "17:00", endTime: "18:00")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "SK핸드볼경기장", artists: [
                        ArtistSchedule(name: "10cm", image: UIImage(named: "artistImg"), startTime: "14:00", endTime: "15:00"),
                        ArtistSchedule(name: "볼빨간사춘기", image: UIImage(named: "artistImg"), startTime: "15:30", endTime: "16:30")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "적재", image: UIImage(named: "artistImg"), startTime: "13:00", endTime: "14:00"),
                        ArtistSchedule(name: "NCT", image: UIImage(named: "artistImg"), startTime: "18:00", endTime: "19:30")
                    ])
                ]
            ]
        )
    ]
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout()).then {
        $0.backgroundColor = .grayBg
        $0.isScrollEnabled = false
        $0.register(FestivalCollectionViewCell.self, forCellWithReuseIdentifier: FestivalCollectionViewCell.identifier)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFestival = festivals[indexPath.item]
        delegate?.didSelectFestival(selectedFestival)
    }
}
