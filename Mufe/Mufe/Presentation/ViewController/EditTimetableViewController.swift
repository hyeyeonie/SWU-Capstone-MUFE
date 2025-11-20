//
//  EditTimetableViewController.swift
//  Mufe
//
//  Created by 신혜연 on 11/19/25.
//

import UIKit

import SnapKit
import Then

class EditTimetableViewController: UIViewController {
    
    // MARK: - Properties
    
    var scheduleList: [ArtistInfo] = []
    var onCompletion: (([String]) -> Void)?

    // MARK: - UI Components
    
    private let timeTableLayout = TimetableLayout()
    private let editTimetableView = EditTimetableView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: timeTableLayout).then {
        $0.backgroundColor = .grayBg
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        
        $0.register(EditTimetableCell.self, forCellWithReuseIdentifier: EditTimetableCell.identifier)
        $0.register(StageHeaderView.self, forSupplementaryViewOfKind: "StageHeader", withReuseIdentifier: StageHeaderView.identifier)
        $0.register(TimeSidebarView.self, forSupplementaryViewOfKind: "TimeSidebar", withReuseIdentifier: TimeSidebarView.identifier)
        $0.register(CornerHeaderView.self, forSupplementaryViewOfKind: "CornerHeader", withReuseIdentifier: CornerHeaderView.identifier)
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setActions()
        setDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        for (sectionIndex, section) in scheduleList.enumerated() {
            for (itemIndex, artist) in section.artists.enumerated() {
                if artist.isSelected {
                    let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
            }
        }
    }
    
    // MARK: - UI Setup
    
    private func setStyle() {
        view.backgroundColor = .grayBg
    }
    
    private func setUI() {
        view.addSubview(editTimetableView)
        editTimetableView.addSubview(collectionView)
    }
    
    private func setLayout() {
        editTimetableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setActions() {
        editTimetableView.completeButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
        editTimetableView.closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    private func setDelegate() {
        timeTableLayout.delegate = self
    }
    
    // MARK: - Actions
    
    @objc private func didTapComplete() {
        var selectedNames: [String] = []
        
        for section in scheduleList {
            for artist in section.artists {
                if artist.isSelected {
                    selectedNames.append(artist.name)
                }
            }
        }
        
        onCompletion?(selectedNames)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func didTapClose() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension EditTimetableViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return scheduleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return scheduleList[section].artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditTimetableCell.identifier, for: indexPath) as? EditTimetableCell else { return UICollectionViewCell() }
        
        let artist = scheduleList[indexPath.section].artists[indexPath.item]
        cell.configure(with: artist)
        
        // 재사용되는 셀의 선택 상태를 데이터모델과 동기화
        cell.isSelected = artist.isSelected
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == "StageHeader" {
            // 상단 스테이지 이름 헤더
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StageHeaderView.identifier, for: indexPath) as! StageHeaderView
            
            let info = scheduleList[indexPath.section]
            header.configure(stage: info.stage, location: info.location)
            
            return header
            
        } else if kind == "TimeSidebar" {
            // 좌측 시간 표시 사이드바
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TimeSidebarView.identifier, for: indexPath) as! TimeSidebarView
            
            let hour = 11 + indexPath.item
            view.configure(hour: hour)
            
            return view
            
        } else if kind == "CornerHeader" {
            // 좌측 상단 빈 공간 (Sticky Header 겹침 방지용)
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CornerHeaderView.identifier, for: indexPath)
        }
        
        return UICollectionReusableView()
    }
    
    // MARK: Selection Logic
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scheduleList[indexPath.section].artists[indexPath.item].isSelected = true
        print("Selected: \(scheduleList[indexPath.section].artists[indexPath.item].name)")
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        scheduleList[indexPath.section].artists[indexPath.item].isSelected = false
        print("Deselected: \(scheduleList[indexPath.section].artists[indexPath.item].name)")
    }
}

// MARK: - TimetableLayout Delegate

extension EditTimetableViewController: TimetableLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, startTimeFor indexPath: IndexPath) -> String {
        return scheduleList[indexPath.section].artists[indexPath.item].startTime
    }
    
    func collectionView(_ collectionView: UICollectionView, endTimeFor indexPath: IndexPath) -> String {
        return scheduleList[indexPath.section].artists[indexPath.item].endTime
    }
    
    func collectionView(_ collectionView: UICollectionView, stageIndexFor indexPath: IndexPath) -> Int {
        return indexPath.section
    }
}
