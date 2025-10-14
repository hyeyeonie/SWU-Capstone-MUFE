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
    
    private var festivalList: [Festival] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(TimetableTabCell.self, forCellWithReuseIdentifier: TimetableTabCell.identifier)
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
    
    func configure(with festivals: [Festival]) {
        self.festivalList = festivals
        collectionView.reloadData()
    }
}

extension TimetableTabView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return festivalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimetableTabCell.identifier, for: indexPath) as? TimetableTabCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: festivalList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 136)
    }
}

#Preview {
    // MARK: - Dummy Data
    
    let dummyArtistInfo1 = ArtistInfo(stage: "Main Stage", location: "A존", artists: [])
    let dummyArtistInfo2 = ArtistInfo(stage: "Second Stage", location: "B존", artists: [])
    
    // ✅ FestivalDay 구조체 예시
    let dummyDays1: [FestivalDay] = [
        FestivalDay(dayOfWeek: "화요일", date: "2025-08-12"),
        FestivalDay(dayOfWeek: "수요일", date: "2025-08-13")
    ]
    
    let dummyDays2: [FestivalDay] = [
        FestivalDay(dayOfWeek: "월요일", date: "2025-09-01"),
        FestivalDay(dayOfWeek: "화요일", date: "2025-09-02")
    ]
    
    let dummyDays3: [FestivalDay] = [
        FestivalDay(dayOfWeek: "금요일", date: "2025-10-10"),
        FestivalDay(dayOfWeek: "토요일", date: "2025-10-11"),
        FestivalDay(dayOfWeek: "일요일", date: "2025-10-12")
    ]
    
    let dummyFestivals: [Festival] = [
        Festival(
            imageName: "festival_seoul",
            name: "뮤직 페스티벌 2025",
            startDate: "2025-08-12",
            endDate: "2025-08-13",
            location: "서울 난지공원",
            artistSchedule: [
                "2025-08-12": [dummyArtistInfo1, dummyArtistInfo2],
                "2025-08-13": [dummyArtistInfo2]
            ],
            days: dummyDays1
        ),
        Festival(
            imageName: "rock_busan",
            name: "락 인 부산",
            startDate: "2025-09-01",
            endDate: "2025-09-02",
            location: "부산 해운대",
            artistSchedule: [
                "2025-09-01": [dummyArtistInfo1]
            ],
            days: dummyDays2
        ),
        Festival(
            imageName: "indie_hongdae",
            name: "인디 뮤직 위크",
            startDate: "2025-10-10",
            endDate: "2025-10-12",
            location: "홍대 거리",
            artistSchedule: [
                "2025-10-10": [dummyArtistInfo2]
            ],
            days: dummyDays3
        )
    ]
    
    let view = TimetableTabView()
    view.configure(with: dummyFestivals)
    return view
}
