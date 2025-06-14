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
    
    // 외부에서 할당 가능, 할당 시 컬렉션뷰 및 UI 자동 갱신
    var timetables: [Timetable] = [] {
        didSet {
            collectionView.reloadData()
            updateCollectionViewHeight()
            updateRunningTime()
        }
    }
    
    private var collectionViewHeightConstraint: Constraint?
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 201)
        layout.minimumLineSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .grayBg
        cv.register(TimetableCell.self, forCellWithReuseIdentifier: TimetableCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        
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
    
    private func updateCollectionViewHeight() {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let itemHeight = layout?.itemSize.height ?? 201
        let lineSpacing = layout?.minimumLineSpacing ?? 0
        
        let itemCount = timetables.count
        
        guard itemCount > 0 else {
            collectionViewHeightConstraint?.update(offset: 0)
            view.layoutIfNeeded()
            return
        }
        
        let totalHeight = CGFloat(itemCount) * itemHeight + CGFloat(itemCount - 1) * lineSpacing
        
        collectionViewHeightConstraint?.update(offset: totalHeight)
        view.layoutIfNeeded()
    }
    
    private func updateRunningTime() {
        let uniqueArtists = Set(timetables.map { $0.artistName })
        let totalMinutes = timetables.reduce(0) { $0 + $1.runningTime }
        
        updateRunningTimeLabel(count: uniqueArtists.count, minutes: totalMinutes)
    }
    
    func updateRunningTimeLabel(count: Int, minutes: Int) {
        runningTimeLabel.text = "총 \(count)개, \(minutes)분"
    }
}

extension PersonalTimetableViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timetables.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimetableCell.identifier, for: indexPath) as? TimetableCell else {
            return UICollectionViewCell()
        }
        
        let timetable = timetables[indexPath.item]
        cell.configure(with: timetable)
        return cell
    }
}

extension PersonalTimetableViewController: UICollectionViewDelegate {
    
}
