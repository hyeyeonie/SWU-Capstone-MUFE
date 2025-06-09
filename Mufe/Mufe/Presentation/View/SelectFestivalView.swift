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
                        (name: "잔나비", image: UIImage(named: "artistImg")),
                        (name: "혁오", image: UIImage(named: "artistImg"))
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "SK핸드볼경기장", artists: [
                        (name: "10cm", image: UIImage(named: "artistImg")),
                        (name: "볼빨간사춘기", image: UIImage(named: "artistImg"))
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        (name: "적재", image: UIImage(named: "artistImg")),
                        (name: "NCT", image: UIImage(named: "artistImg"))
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
                        (name: "잔나비", image: UIImage(named: "artistImg")),
                        (name: "혁오", image: UIImage(named: "artistImg"))
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "SK핸드볼경기장", artists: [
                        (name: "10cm", image: UIImage(named: "artistImg")),
                        (name: "볼빨간사춘기", image: UIImage(named: "artistImg"))
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        (name: "적재", image: UIImage(named: "artistImg")),
                        (name: "NCT", image: UIImage(named: "artistImg"))
                    ])
                ]
            ]
        ),
        Festival(
            imageName: "fstImg",
            name: "2025 NCT",
            startDate: "2025.01.03",
            endDate: "2025.01.06",
            location: "올림픽공원",
            artistSchedule: [
                "1일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        (name: "잔나비", image: UIImage(named: "artistImg")),
                        (name: "혁오", image: UIImage(named: "artistImg"))
                    ]),
                    ArtistInfo(stage: "STAGE 2", location: "SK핸드볼경기장", artists: [
                        (name: "10cm", image: UIImage(named: "artistImg")),
                        (name: "볼빨간사춘기", image: UIImage(named: "artistImg"))
                    ])
                ],
                "2일차": [
                    ArtistInfo(stage: "STAGE 1", location: "88잔디마당", artists: [
                        (name: "적재", image: UIImage(named: "artistImg")),
                        (name: "NCT", image: UIImage(named: "artistImg"))
                    ])
                ]
            ]
        )
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
