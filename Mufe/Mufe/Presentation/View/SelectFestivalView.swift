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
            imageName: "beautiful_mint_life",
            name: "2025 뷰티풀민트라이프",
            startDate: "2025.06.13",
            endDate: "2025.06.15",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Hi-Fi Un!corn", image: UIImage(named: "hifi"), startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "유주", image: UIImage(named: "yuzu"), startTime: "14:50", endTime: "15:40"),
                        ArtistSchedule(name: "오월오일", image: UIImage(named: "maymay"), startTime: "16:10", endTime: "17:00"),
                        ArtistSchedule(name: "SAM KIM", image: UIImage(named: "samkim"), startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "선우정아", image: UIImage(named: "sunsun"), startTime: "18:50", endTime: "19:50"),
                        ArtistSchedule(name: "터치드", image: UIImage(named: "touched"), startTime: "20:30", endTime: "21:30")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "AxMxP", image: UIImage(named: "axmxp"), startTime: "14:30", endTime: "15:10"),
                        ArtistSchedule(name: "Glen Check", image: UIImage(named: "glencheck"), startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "The Solutions", image: UIImage(named: "thesoultions"), startTime: "17:00", endTime: "17:50"),
                        ArtistSchedule(name: "QWER", image: UIImage(named: "qwer"), startTime: "18:20", endTime: "19:10"),
                        ArtistSchedule(name: "이승윤", image: UIImage(named: "seungyoon"), startTime: "19:40", endTime: "20:40"),
                        ArtistSchedule(name: "YB", image: UIImage(named: "yb"), startTime: "21:20", endTime: "22:20")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "88호수 수변무대", artists: [
                        ArtistSchedule(name: "orange flavored cigarettes", image: UIImage(named: "ofc"), startTime: "14:10", endTime: "14:50"),
                        ArtistSchedule(name: "김승주", image: UIImage(named: "seungjoo"), startTime: "15:20", endTime: "16:00"),
                        ArtistSchedule(name: "DASUTT", image: UIImage(named: "dasutt"), startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "황가람", image: UIImage(named: "garam"), startTime: "17:50", endTime: "18:40"),
                        ArtistSchedule(name: "옥상달빛", image: UIImage(named: "okdal"), startTime: "19:10", endTime: "20:10"),
                        ArtistSchedule(name: "하동균", image: UIImage(named: "donggyun"), startTime: "20:40", endTime: "21:40")
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "Dragon Pony", image: UIImage(named: "dragonpony"), startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "방예담", image: UIImage(named: "yedam"), startTime: "14:10", endTime: "15:00"),
                        ArtistSchedule(name: "소수빈", image: UIImage(named: "soobin"), startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "소란", image: UIImage(named: "soran"), startTime: "17:10", endTime: "18:00"),
                        ArtistSchedule(name: "하현상", image: UIImage(named: "hyeonsang"), startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "정승환", image: UIImage(named: "seunghwan"), startTime: "20:20", endTime: "21:20")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "O.O.O", image: UIImage(named: "ooo"), startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "리도어", image: UIImage(named: "redoor"), startTime: "15:00", endTime: "15:50"),
                        ArtistSchedule(name: "너드커넥션", image: UIImage(named: "nerdnerd"), startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "페퍼톤스", image: UIImage(named: "peppertones"), startTime: "18:00", endTime: "18:50"),
                        ArtistSchedule(name: "N.Flying", image: UIImage(named: "nflying"), startTime: "19:30", endTime: "20:30"),
                        ArtistSchedule(name: "실리카겔", image: UIImage(named: "silicagel"), startTime: "21:10", endTime: "22:10")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "88호수 수변무대", artists: [
                        ArtistSchedule(name: "0WAVE", image: UIImage(named: "wave0"), startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "이강승", image: UIImage(named: "kangseung"), startTime: "14:50", endTime: "15:30"),
                        ArtistSchedule(name: "까치산", image: UIImage(named: "kachisan"), startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "dori", image: UIImage(named: "dori"), startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "권순관", image: UIImage(named: "soonkwan"), startTime: "19:00", endTime: "20:00"),
                        ArtistSchedule(name: "george", image: UIImage(named: "george"), startTime: "20:40", endTime: "21:40")
                    ])
                ],
                "3일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        ArtistSchedule(name: "우석", image: UIImage(named: "wooseok"), startTime: "13:00", endTime: "13:40"),
                        ArtistSchedule(name: "한로로", image: UIImage(named: "hanroro"), startTime: "14:10", endTime: "15:00"),
                        ArtistSchedule(name: "유다빈밴드", image: UIImage(named: "ydbb"), startTime: "15:40", endTime: "16:30"),
                        ArtistSchedule(name: "로이킴", image: UIImage(named: "roykim"), startTime: "17:10", endTime: "18:00"),
                        ArtistSchedule(name: "김성규", image: UIImage(named: "sungkyu"), startTime: "18:40", endTime: "19:40"),
                        ArtistSchedule(name: "윤하", image: UIImage(named: "younha"), startTime: "20:20", endTime: "21:20")
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "KSPO DOME", artists: [
                        ArtistSchedule(name: "구원찬", image: UIImage(named: "onechan"), startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "Colde", image: UIImage(named: "colde"), startTime: "15:00", endTime: "15:50"),
                        ArtistSchedule(name: "적재", image: UIImage(named: "jukjae"), startTime: "16:30", endTime: "17:20"),
                        ArtistSchedule(name: "이석훈", image: UIImage(named: "seokhoon"), startTime: "18:00", endTime: "18:50"),
                        ArtistSchedule(name: "10cm", image: UIImage(named: "tencm"), startTime: "19:30", endTime: "20:30"),
                        ArtistSchedule(name: "다비치", image: UIImage(named: "davichi"), startTime: "21:10", endTime: "22:10")
                    ]),
                    ArtistInfo(stage: "STAGE 3", location: "88호수 수변무대", artists: [
                        ArtistSchedule(name: "Dept", image: UIImage(named: "dept"), startTime: "13:40", endTime: "14:20"),
                        ArtistSchedule(name: "연정", image: UIImage(named: "yeonjeong"), startTime: "14:50", endTime: "15:30"),
                        ArtistSchedule(name: "안다영", image: UIImage(named: "dayeong"), startTime: "16:00", endTime: "16:50"),
                        ArtistSchedule(name: "오존", image: UIImage(named: "ozone"), startTime: "17:30", endTime: "18:20"),
                        ArtistSchedule(name: "브로콜리너마저", image: UIImage(named: "broccoli"), startTime: "19:00", endTime: "20:00"),
                        ArtistSchedule(name: "데이먼스 이어", image: UIImage(named: "damonsyear"), startTime: "20:40", endTime: "21:40")
                    ])
                ]
            ]
        ),
        
        Festival(
                    imageName: "asian_pop_fes",
                    name: "ASIAN POP FESTIVAL 2025",
                    startDate: "2025.06.21",
                    endDate: "2025.06.22",
                    location: "파라다이스시티",
                    artistSchedule: [:]
        ),

        Festival(
                    imageName: "seoul_park_music",
                    name: "ASIAN POP FESTIVAL 2025",
                    startDate: "2025.06.28",
                    endDate: "2025.06.29",
                    location: "올림픽공원",
                    artistSchedule: [:]
        ),

        Festival(
                    imageName: "sound_berry",
                    name: "SOUNDBERRY FESTA’ 25",
                    startDate: "2025.07.19",
                    endDate: "2025.07.20",
                    location: "일산 킨텍스 제 2전시장 9홀",
                    artistSchedule: [:]
        ),

        Festival(
                    imageName: "icn_pentaport",
                    name: "KB국민카드 스타샵 with 2025 인천펜타포트 락 페스티벌",
                    startDate: "2025.08.01",
                    endDate: "2025.08.03",
                    location: "송도달빛축제공원",
                    artistSchedule: [:]
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
