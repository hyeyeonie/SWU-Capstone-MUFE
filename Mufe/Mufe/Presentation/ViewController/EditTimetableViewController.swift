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
    
    let dayString: String
    
    var scheduleList: [ArtistInfo] = []
    var onCompletion: (([String]) -> Void)?

    private let timeTableLayout = TimetableLayout()
    private let editTimetableView = EditTimetableView()
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: timeTableLayout).then {
        $0.backgroundColor = .grayBg
        $0.dataSource = self
        $0.delegate = self
        $0.allowsMultipleSelection = true
        
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
        $0.register(EditTimetableCell.self, forCellWithReuseIdentifier: EditTimetableCell.identifier)
        $0.register(StageHeaderView.self, forSupplementaryViewOfKind: "StageHeader", withReuseIdentifier: StageHeaderView.identifier)
        $0.register(TimeSidebarView.self, forSupplementaryViewOfKind: "TimeSidebar", withReuseIdentifier: TimeSidebarView.identifier)
        $0.register(CornerHeaderView.self, forSupplementaryViewOfKind: "CornerHeader", withReuseIdentifier: CornerHeaderView.identifier)
    }
    
    init(dayString: String) {
        self.dayString = dayString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setActions()
        setDelegate()
        
        editTimetableView.configure(dayString: self.dayString)
        
        let calculatedStartHour = findMinStartHour()
        timeTableLayout.dynamicStartHour = calculatedStartHour
        timeTableLayout.dynamicEndHour = findMaxEndHour(minStartHour: calculatedStartHour)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        for (sectionIndex, section) in scheduleList.enumerated() {
            for (itemIndex, artist) in section.artists.enumerated() {
                if artist.isSelected {
                    let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                    self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                }
            }
        }
    }
    
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
    
    private func findMinStartHour() -> Int {
        var earliestStartTimeInMinutes = Int.max

        for section in scheduleList {
            for artist in section.artists {
                let components = artist.startTime.split(separator: ":").compactMap { Int($0) }
                guard components.count == 2 else { continue }
                
                var hour = components[0]
                let minute = components[1]
                
                if hour >= 0 && hour <= 4 {
                    hour += 24
                }
                
                let totalMinutes = hour * 60 + minute
                
                if totalMinutes < earliestStartTimeInMinutes {
                    earliestStartTimeInMinutes = totalMinutes
                }
            }
        }
        
        if earliestStartTimeInMinutes == Int.max {
            return 11
        }

        let paddedStartTimeInMinutes = max(0, earliestStartTimeInMinutes - 30)

        let startHourForLayout = Int(floor(Double(paddedStartTimeInMinutes) / 60.0))
        
        return max(0, startHourForLayout)
    }
    
    private func findMaxEndHour(minStartHour: Int) -> Int {
        var latestEndTimeInMinutes = 0
        
        for section in scheduleList {
            for artist in section.artists {
                let components = artist.endTime.split(separator: ":").compactMap { Int($0) }
                guard components.count == 2 else { continue }
                
                var hour = components[0]
                let minute = components[1]
                
                if hour >= 0 && hour <= 4 {
                    hour += 24
                }
                
                let totalMinutes = hour * 60 + minute
                
                if totalMinutes > latestEndTimeInMinutes {
                    latestEndTimeInMinutes = totalMinutes
                }
            }
        }
        
        let paddedEndTimeInMinutes = latestEndTimeInMinutes + 30
        
        let endHourForLayout = Int(ceil(Double(paddedEndTimeInMinutes) / 60.0))
        
        return max(minStartHour + 1, endHourForLayout)
    }
    
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
        
        cell.isSelected = artist.isSelected
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == "StageHeader" {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StageHeaderView.identifier, for: indexPath) as! StageHeaderView
            
            let info = scheduleList[indexPath.section]
            header.configure(stage: info.stage, location: info.location)
            
            return header
            
        } else if kind == "TimeSidebar" {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TimeSidebarView.identifier, for: indexPath) as! TimeSidebarView
            
            let startHour = timeTableLayout.dynamicStartHour
            var hour = startHour + indexPath.item
            
            if hour >= 24 {
                hour -= 24
            }
            
            view.configure(hour: hour)
            
            return view
            
        } else if kind == "CornerHeader" {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CornerHeaderView.identifier, for: indexPath)
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scheduleList[indexPath.section].artists[indexPath.item].isSelected = true
        print("Selected: \(scheduleList[indexPath.section].artists[indexPath.item].name)")
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        scheduleList[indexPath.section].artists[indexPath.item].isSelected = false
        print("Deselected: \(scheduleList[indexPath.section].artists[indexPath.item].name)")
    }
}

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
