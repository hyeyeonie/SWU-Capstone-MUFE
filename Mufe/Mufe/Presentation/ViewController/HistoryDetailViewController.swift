//
//  HistoryDetailViewController.swift
//  Mufe
//
//  Created by 신혜연 on 10/19/25.
//

import UIKit

import SnapKit
import Then

class HistoryDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var festival: Festival?
    var allSavedDays: [SavedFestival] = []
    private var currentSavedDay: SavedFestival?
    
    private var selectedDayKey: String = ""
    private var artistsForSelectedDay: [ArtistSchedule] = []
    private var memoryCache: [String: Memory] = [:]
    private var dayItems: [DayItem] = []
    
    // MARK: - UI Components
    
    private let backButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = .gray00
    }
    
    private let festivalNameLabel = UILabel().then {
        $0.textColor = .gray00
        $0.customFont(.flg_SemiBold)
    }
    
    private var dayButtons: [DaySelectionButton] = []
    
    private let daySelectionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private lazy var historyCollectionView: UICollectionView = {
        let layout = createListLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.register(HistoryCell.self, forCellWithReuseIdentifier: HistoryCell.identifier)
        return cv
    }()
    
    private let inputDateFormatter = DateFormatter().then {
        $0.dateFormat = "M월 d일 EEEE"
        $0.locale = Locale(identifier: "ko_KR")
        $0.timeZone = TimeZone(identifier: "Asia/Seoul")
    }
    
    private let outputDateFormatter = DateFormatter().then {
        $0.dateFormat = "M.d"
        $0.locale = Locale(identifier: "ko_KR")
        $0.timeZone = TimeZone(identifier: "Asia/Seoul")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSytle()
        setUI()
        setLayout()
        setAction()
        configureData()
    }
    
    private func setSytle() {
        view.backgroundColor = .grayBg
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func setUI() {
        view.addSubviews(backButton, festivalNameLabel, daySelectionStackView, historyCollectionView)
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(24)
        }
        
        festivalNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
        }
        
        daySelectionStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(126)
            $0.leading.equalToSuperview().inset(16)
        }
        
        historyCollectionView.snp.makeConstraints {
            $0.top.equalTo(daySelectionStackView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureData() {
        guard let festival = festival else {
            print("🚨 HistoryDetailVC: Festival 데이터가 없습니다.")
            return
        }
        
        festivalNameLabel.text = festival.name
        
        let itemsForTabs = allSavedDays
            .sorted(by: { $0.selectedDay < $1.selectedDay })
            .map { savedFestival -> DayItem in
                
                var shortDateString = ""
                let originalDateString = savedFestival.selectedDate // "5월 17일 토요일"
                
                print("Processing date: \(originalDateString) with format: \(inputDateFormatter.dateFormat ?? "nil")")
                
                if let dateObject = inputDateFormatter.date(from: originalDateString) {
                    shortDateString = outputDateFormatter.string(from: dateObject)
                    print("✅ Parsing SUCCESS: \(originalDateString) -> \(shortDateString)")
                } else {
                    print("🚨 Parsing FAILED for: \(originalDateString).")
                    shortDateString = "?" // 실패 시 ? 표시
                }
                
                return DayItem(
                    title: savedFestival.selectedDay.replacingOccurrences(of: "DAY ", with: ""),
                    date: shortDateString
                )
            }
        self.dayItems = itemsForTabs
        setupDaySelectionTabs(with: itemsForTabs)
        
            if let firstDay = itemsForTabs.first, !allSavedDays.isEmpty {
                self.selectedDayKey = allSavedDays.first!.selectedDay
                selectDay(title: firstDay.title)
                updateForSelectedDay(dayKey: self.selectedDayKey)
            }
    }
    
    private func setAction() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private func setupDaySelectionTabs(with items: [DayItem]) {
        self.dayItems = items
        
        daySelectionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dayButtons.removeAll()
        
        for (index, item) in items.enumerated() {
            let button = DaySelectionButton()
            button.configure(with: item)
            
            button.tag = index
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            
            daySelectionStackView.addArrangedSubview(button)
            dayButtons.append(button)
        }
    }
    
    private func selectDay(title: String) {
        guard let index = dayItems.firstIndex(where: { $0.title == title }) else { return }
        
        dayButtons.forEach { $0.isSelected = false }
        dayButtons[index].isSelected = true
    }
    
    @objc private func dayButtonTapped(_ sender: DaySelectionButton) {
        dayButtons.forEach { $0.isSelected = false }
        
        sender.isSelected = true
        
        let originalSavedFestival = allSavedDays[sender.tag]
        self.selectedDayKey = originalSavedFestival.selectedDay
        
        updateForSelectedDay(dayKey: selectedDayKey)
    }

    private func updateForSelectedDay(dayKey: String) {
        self.selectedDayKey = dayKey
        
        guard let savedDay = allSavedDays.first(where: { $0.selectedDay == dayKey }) else {
            print("🚨 \(dayKey)에 해당하는 SavedFestival 데이터를 찾을 수 없습니다.")
            self.currentSavedDay = nil
            self.artistsForSelectedDay = []
            self.memoryCache = [:]
            historyCollectionView.reloadData()
            return
        }
        
        self.currentSavedDay = savedDay
        self.artistsForSelectedDay = savedDay.timetables.map { savedTimetable -> ArtistSchedule in
            return ArtistSchedule(
                name: savedTimetable.artistName,
                image: savedTimetable.artistImage,
                startTime: savedTimetable.startTime,
                endTime: savedTimetable.endTime
            )
        }.sorted(by: { $0.startTime < $1.startTime })
        
        print("Artists for \(dayKey) (from SavedFestival): \(artistsForSelectedDay.map { $0.name })")
        
        loadMemories()
    }
    
    private func loadMemories() {
        guard let savedDay = currentSavedDay else {
            print("loadMemories: currentSavedDay가 nil입니다.")
            self.memoryCache = [:]
            historyCollectionView.reloadData()
            return
        }
        
        var newMemoryCache: [String: Memory] = [:]
        
        for savedTimetable in savedDay.timetables {
            if let artistMemory = savedTimetable.memory {
                let memoryStruct = Memory(
                    text: artistMemory.reviewText,
                    photoNames: artistMemory.photoIdentifiers
                )
                newMemoryCache[savedTimetable.artistName] = memoryStruct
                print("✅ \(savedTimetable.artistName)의 추억 로드 완료.")
            } else {
                print("ℹ️ \(savedTimetable.artistName)의 추억 데이터(ArtistMemory) 없음.")
            }
        }
        
        self.memoryCache = newMemoryCache
        print("Reloading collection view with fetched memories.")
        historyCollectionView.reloadData()
    }
    
    // MARK: - Actions
    
    @objc private func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func handleDidTapAddMemory(for artist: ArtistSchedule, existingMemory: ArtistMemory?) {
        print("✍️ '추억 남기기' VC로 이동 (아티스트: \(artist.name))")

        guard let currentSavedDayData = currentSavedDay else {
            print("🚨 MemoryEditVC 띄우기 실패: currentSavedDay 없음")
            return
        }

        let editVC = MemoryEditViewController()
        editVC.artist = artist
        editVC.dayKey = self.selectedDayKey
        editVC.savedFestivalId = currentSavedDayData.id
        editVC.existingMemory = existingMemory
        editVC.delegate = self
        editVC.modalPresentationStyle = .fullScreen
        self.present(editVC, animated: true)
    }
    
    private func handleDidTapMoreOptions(for artist: ArtistSchedule, sender: UIButton) {
        print("... '수정/삭제' 메뉴 표시 (아티스트: \(artist.name))")
        
        let editAction = UIAction(title: "수정하기", image: UIImage(systemName: "pencil")) { [weak self] _ in
            guard let self = self else { return }
            guard let existingMemory = self.currentSavedDay?.timetables
                .first(where: { $0.artistName == artist.name })?.memory else {
                print("🚨 수정할 Memory 데이터가 없습니다.")
                return
            }
            self.handleDidTapAddMemory(for: artist, existingMemory: existingMemory)
        }
        
        let deleteAction = UIAction(
            title: "삭제하기",
            image: UIImage(systemName: "trash"),
            attributes: .destructive
        ) { [weak self] _ in
            guard let self = self else { return }
            guard let currentSavedDay = self.currentSavedDay else { return }
            guard let timetableIndex = currentSavedDay.timetables.firstIndex(where: { $0.artistName == artist.name }) else {
                print("🚨 삭제 실패: 타임테이블을 찾을 수 없음")
                return
            }
            
            guard let memoryToDelete = currentSavedDay.timetables[timetableIndex].memory else {
                print("ℹ️ 삭제할 메모가 없습니다.")
                self.memoryCache[artist.name] = nil
                self.historyCollectionView.reloadData()
                return
            }
            
            let alert = UIAlertController(
                title: "추억 삭제",
                message: "\(artist.name)의 추억을 삭제하시겠어요?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
                if let ctx = memoryToDelete.modelContext {
                    ctx.delete(memoryToDelete)
                    do {
                        try ctx.save()
                        print("✅ \(artist.name)의 추억 삭제 완료 (SwiftData)")
                    } catch {
                        print("🚨 SwiftData 저장 오류: \(error)")
                    }
                } else if let ctx = currentSavedDay.modelContext {
                    ctx.delete(memoryToDelete)
                    do { try ctx.save() } catch { print("🚨 save error: \(error)") }
                } else {
                    print("🚨 모델 컨텍스트를 찾을 수 없어 삭제를 수행하지 못했습니다.")
                }
                
                currentSavedDay.timetables[timetableIndex].memory = nil
                self.memoryCache[artist.name] = nil
                self.updateForSelectedDay(dayKey: self.selectedDayKey)
            })
            
            self.present(alert, animated: true)
        }
        
        let menu = UIMenu(title: "", children: [editAction, deleteAction])
        
        sender.menu = menu
        sender.showsMenuAsPrimaryAction = true
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 40, trailing: 16)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension HistoryDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistsForSelectedDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCell.identifier, for: indexPath) as? HistoryCell else {
            return UICollectionViewCell()
        }
        
        let artist = artistsForSelectedDay[indexPath.item]
        let memory = memoryCache[artist.name]
        
        cell.configure(artist: artist, memory: memory)
        
        cell.didTapAddMemory = { [weak self] in
            guard let self = self else { return }
            let existingMemory = self.currentSavedDay?.timetables
                .first(where: { $0.artistName == artist.name })?.memory
            self.handleDidTapAddMemory(for: artist, existingMemory: existingMemory)
        }
        
        cell.didTapMoreOptions = { [weak self] senderButton in
            self?.handleDidTapMoreOptions(for: artist, sender: senderButton)
        }
        
        return cell
    }
}

extension HistoryDetailViewController: UICollectionViewDelegate { }

extension HistoryDetailViewController: MemoryEditDelegate {
    func memoryDidSave(for artistName: String, dayKey: String) {
        print("🔄 Memory saved for \(artistName) on \(dayKey). Refreshing...")
        if dayKey == self.selectedDayKey {
             updateForSelectedDay(dayKey: dayKey)
        }
    }
}

extension HistoryDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.navigationController?.viewControllers.count ?? 0) > 1
    }
}

#Preview {
    HistoryDetailViewController()
}
