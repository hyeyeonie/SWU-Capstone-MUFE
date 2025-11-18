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
    var selectedDateItem: DateItem?
    var timetablePreference: Preference?
    var existingSavedDays: [SavedFestival] = []
    
    var timetables: [Timetable] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var collectionViewHeightConstraint: Constraint?
    
    private let recommendLabel = UILabel().then {
        $0.text = "이 공연들은 어때요?"
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
        layout.minimumLineSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .grayBg
        cv.register(TimetableCell.self, forCellWithReuseIdentifier: TimetableCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // Buttons
    private let buttonBackgroundView = UIImageView().then {
        $0.image = UIImage(named: "buttonBackground")
        $0.isUserInteractionEnabled = true
    }
    
    private let completeButton = UIButton().then {
        $0.backgroundColor = .primary50
        $0.setTitle("무대 담기", for: .normal)
        $0.setTitleColor(.gray00, for: .normal)
        $0.titleLabel?.customFont(.flg_SemiBold)
        $0.layer.cornerRadius = 16
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        updateCollectionViewHeight()
        updateRunningTime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    private func setStyle() {
        view.backgroundColor = .grayBg
    }
    
    private func setUI() {
        view.addSubviews(recommendLabel, runningTimeLabel, mufeImageView, collectionView, buttonBackgroundView, completeButton)
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
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(buttonBackgroundView.snp.top)
        }
        
        // Buttons
        buttonBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(101)
        }

        completeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(buttonBackgroundView.snp.bottom).offset(-24)
            $0.height.equalTo(53)
        }
    }
    
    private func setAction() {
        completeButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
    }
    
    @objc private func didTapComplete() {
        guard let festival = self.selectedFestival,
              let dateItem = self.selectedDateItem,
              let nav = self.navigationController else {
            print("Error: 저장할 정보가 부족합니다.")
            return
        }

        // [Timetable]을 DB에 저장할 [SavedTimetable] 형태로 변환
        let savedTimetables: [SavedTimetable] = self.timetables.map { timetable in
            let originalArtistInfo = festival.artistSchedule[dateItem.day]?
                .first { stage in stage.artists.contains(where: { $0.name == timetable.artistName }) }
            let originalArtist = originalArtistInfo?.artists.first { $0.name == timetable.artistName }

            let artistImage = originalArtist?.image ?? "defaultArtistImage"
            let stage = originalArtistInfo?.stage ?? "알 수 없는 스테이지"

            return SavedTimetable(from: timetable, artistImage: artistImage, stage: stage)
        }

        let newSavedFestival = SavedFestival(
            festival: festival,
            selectedDateItem: dateItem,
            timetables: savedTimetables
        )

        SwiftDataManager.shared.context.insert(newSavedFestival)
        print("💾 \(newSavedFestival.festivalName) 타임테이블 저장 완료!")
        
        for timetable in newSavedFestival.timetables {
            NotificationManager.shared.schedulePerformanceReminder(timetable: timetable,
                                                                   festival: newSavedFestival)
        }
        
        NotificationManager.shared.schedulePostFestivalReminder(festival: newSavedFestival)

        let finalTimetableVC = MadeTimetableViewController()
        finalTimetableVC.festival = festival
        finalTimetableVC.selectedDateItem = dateItem
        finalTimetableVC.timetables = self.timetables
        finalTimetableVC.timetablePreference = self.timetablePreference
        finalTimetableVC.savedFestival = newSavedFestival
        finalTimetableVC.allSavedDays = self.existingSavedDays + [newSavedFestival]
        
        finalTimetableVC.isFromCellSelection = true
        finalTimetableVC.isFromHome = false
        
        var viewControllers = nav.viewControllers
        viewControllers.removeLast(2)
        viewControllers.append(finalTimetableVC)
        nav.setViewControllers(viewControllers, animated: true)
    }
    
    @objc private func didTapEdit() {
        // TODO: 수정하기 버튼 로직 구현
        navigationController?.popViewController(animated: true)
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

extension PersonalTimetableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 201)
    }
}

extension PersonalTimetableViewController: UICollectionViewDelegate {
    
}
