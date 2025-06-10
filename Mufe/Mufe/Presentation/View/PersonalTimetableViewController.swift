//
//  PersonalTimetableViewController.swift
//  Mufe
//
//  Created by 신혜연 on 6/10/25.
//

import UIKit

import SnapKit
import Then

final class PersonalTimetableViewController: UIViewController {
    
    var selectedFestival: Festival?
    private var timetableDataList: [TimetableData] = []
    
    private let recommendLabel = UILabel().then {
        $0.text = "이 공연은 어때요?"
        $0.customFont(.f2xl_Bold)
        $0.textColor = .gray00
    }
    
    private let runningTimeLabel = UILabel().then {
        $0.customFont(.flg_Medium)
        $0.textColor = .gray40
    }
    
    private let mufeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "mufe")
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 201)
        $0.collectionViewLayout = layout
        $0.backgroundColor = .grayBg
        $0.register(TimetableCell.self, forCellWithReuseIdentifier: TimetableCell.identifier)
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        
        loadDummyData()
        updateRunningTime()
    }
    
    private func setStyle() {
        view.backgroundColor = .grayBg
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUI() {
        view.addSubviews(recommendLabel, runningTimeLabel, mufeImageView, collectionView)
    }
    
    private func setLayout() {
        recommendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(86)
            $0.leading.equalToSuperview().offset(16)
        }
        
        runningTimeLabel.snp.makeConstraints {
            $0.top.equalTo(recommendLabel.snp.bottom).offset(4)
            $0.leading.equalTo(recommendLabel)
        }
        
        mufeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(119)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(mufeImageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-24)
        }
    }
    
    private func loadDummyData() {
        timetableDataList = [
            TimetableData(artistName: "잔나비", location: "88잔디마당", startTime: "15:00", endTime: "16:30", duration: 90, genre: "인디"),
            TimetableData(artistName: "혁오", location: "88잔디마당", startTime: "17:00", endTime: "18:00", duration: 60, genre: "록"),
            TimetableData(artistName: "10cm", location: "SK핸드볼경기장", startTime: "14:00", endTime: "15:00", duration: 60, genre: "포크"),
        ]
        collectionView.reloadData()
    }
    
    private func updateRunningTime() {
        let uniqueArtists = Set(timetableDataList.map { $0.artistName })
        let totalMinutes = timetableDataList.reduce(0) { $0 + $1.duration }
        
        updateRunningTimeLabel(count: uniqueArtists.count, minutes: totalMinutes)
    }
    
    func updateRunningTimeLabel(count: Int, minutes: Int) {
        runningTimeLabel.text = "총 \(count)개, \(minutes)분"
    }
}

extension PersonalTimetableViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        timetableDataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimetableCell.identifier, for: indexPath) as? TimetableCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: timetableDataList[indexPath.item])
        return cell
    }
}

extension PersonalTimetableViewController: UICollectionViewDelegate {

}
