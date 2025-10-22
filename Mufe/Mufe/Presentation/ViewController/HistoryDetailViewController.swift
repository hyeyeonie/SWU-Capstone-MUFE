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
        $0.dateFormat = "M월 d일 EEEE" // 👈 "yyyy.MM.dd" -> "M월 d일 EEEE" 로 변경!
        $0.locale = Locale(identifier: "ko_KR") // 한국어 요일/월 이름 인식
        $0.timeZone = TimeZone(identifier: "Asia/Seoul")
    }
    // (outputDateFormatter는 "M.d" 그대로 유지)
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
        
        // 1. 상단 탭 뷰 구성 (allSavedDays는 SavedFestival 배열)
        let itemsForTabs = allSavedDays
            .sorted(by: { $0.selectedDay < $1.selectedDay })
            .map { savedFestival -> DayItem in
                
                var shortDateString = ""
                let originalDateString = savedFestival.selectedDate // "5월 17일 토요일"
                
                print("Processing date: \(originalDateString) with format: \(inputDateFormatter.dateFormat ?? "nil")")
                
                if let dateObject = inputDateFormatter.date(from: originalDateString) {
                    shortDateString = outputDateFormatter.string(from: dateObject) // "5.17"
                    print("✅ Parsing SUCCESS: \(originalDateString) -> \(shortDateString)")
                } else {
                    // (파싱 실패 시 대체 로직 - 이제 거의 실행되지 않을 것임)
                    print("🚨 Parsing FAILED for: \(originalDateString).")
                    shortDateString = "?" // 실패 시 "?" 표시
                }
                
                return DayItem(
                    title: savedFestival.selectedDay.replacingOccurrences(of: "DAY ", with: ""),
                    date: shortDateString
                )
            }
        self.dayItems = itemsForTabs
        setupDaySelectionTabs(with: itemsForTabs)
        
            // 2. 첫 번째 탭을 기본으로 선택
            if let firstDay = itemsForTabs.first, !allSavedDays.isEmpty {
                self.selectedDayKey = allSavedDays.first!.selectedDay // "1일차" (원본 키)
                selectDay(title: firstDay.title) // "1일차" (버튼 매칭용)
                updateForSelectedDay(dayKey: self.selectedDayKey)
            }
    }
    
    /// 탭 버튼, 백버튼 등 액션을 연결합니다.
    private func setAction() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private func setupDaySelectionTabs(with items: [DayItem]) { // ⭐️ 인자 타입을 DayItem으로 변경
        self.dayItems = items
        
        // 스택뷰 비우기
        daySelectionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dayButtons.removeAll()
        
        // 버튼 새로 만들기
        for (index, item) in items.enumerated() {
            let button = DaySelectionButton()
            button.configure(with: item)
            
            button.tag = index
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            
            daySelectionStackView.addArrangedSubview(button)
            dayButtons.append(button)
        }
    }
    
    private func selectDay(title: String) { // ⭐️ key 대신 title로 매칭
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
    
    // MARK: - ⭐️ 데이터 로드 및 UI 업데이트
    
    /// 선택된 날짜에 맞는 아티스트 리스트와 추억 데이터를 불러옵니다.
    private func updateForSelectedDay(dayKey: String) {
        self.selectedDayKey = dayKey // "1일차"
        
        // ⭐️⭐️⭐️ 1. allSavedDays에서 현재 선택된 날짜(dayKey)에 해당하는 SavedFestival 찾기 ⭐️⭐️⭐️
        guard let savedDay = allSavedDays.first(where: { $0.selectedDay == dayKey }) else {
            print("🚨 \(dayKey)에 해당하는 SavedFestival 데이터를 찾을 수 없습니다.")
            self.currentSavedDay = nil // ⭐️ nil로 설정
            self.artistsForSelectedDay = []
            self.memoryCache = [:] // ⭐️ 캐시 비우기
            historyCollectionView.reloadData()
            return
        }
        // ⭐️ 찾은 SavedFestival을 프로퍼티에 저장
        self.currentSavedDay = savedDay
        
        // ⭐️⭐️⭐️ 2. 찾은 SavedFestival의 timetables ([SavedTimetable])를 ArtistSchedule 형태로 변환 ⭐️⭐️⭐️
        self.artistsForSelectedDay = savedDay.timetables.map { savedTimetable -> ArtistSchedule in
            return ArtistSchedule(
                name: savedTimetable.artistName,
                image: savedTimetable.artistImage,
                startTime: savedTimetable.startTime,
                endTime: savedTimetable.endTime
            )
        }.sorted(by: { $0.startTime < $1.startTime })
        
        print("Artists for \(dayKey) (from SavedFestival): \(artistsForSelectedDay.map { $0.name })")
        
        // 3. ⭐️ SwiftData에서 실제 추억 데이터 로드
        loadMemories()
    }
    
    private func loadMemories() {
        // 1. 현재 선택된 SavedFestival 데이터가 있는지 확인
        guard let savedDay = currentSavedDay else {
            print("loadMemories: currentSavedDay가 nil입니다.")
            self.memoryCache = [:] // 캐시 비우기
            historyCollectionView.reloadData()
            return
        }
        
        // 2. 메모리 캐시 초기화
        var newMemoryCache: [String: Memory] = [:]
        
        // 3. 현재 날짜의 저장된 타임테이블(SavedTimetable) 목록 순회
        for savedTimetable in savedDay.timetables {
            // 4. 각 SavedTimetable에 연결된 ArtistMemory 확인
            if let artistMemory = savedTimetable.memory {
                // 5. ArtistMemory -> Memory struct 변환
                let memoryStruct = Memory(
                    text: artistMemory.reviewText,
                    photoNames: artistMemory.photoIdentifiers
                )
                // 6. 아티스트 이름을 키로 캐시에 저장
                newMemoryCache[savedTimetable.artistName] = memoryStruct
                print("✅ \(savedTimetable.artistName)의 추억 로드 완료.")
            } else {
                print("ℹ️ \(savedTimetable.artistName)의 추억 데이터(ArtistMemory) 없음.")
                // newMemoryCache에 해당 아티스트 키가 없으면 HistoryCell은 자동으로 'Empty' 상태 표시
            }
        }
        
        // 7. 완성된 캐시로 교체
        self.memoryCache = newMemoryCache
        
        // 8. 컬렉션뷰 리로드 (이제 실제 데이터 또는 빈 상태 반영)
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
    
    /// HistoryCell의 '더보기(...)' 버튼이 눌렸을 때 호출
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
            
            // 1) 타임테이블 인덱스 찾기
            guard let timetableIndex = currentSavedDay.timetables.firstIndex(where: { $0.artistName == artist.name }) else {
                print("🚨 삭제 실패: 타임테이블을 찾을 수 없음")
                return
            }
            
            // 2) 삭제할 ArtistMemory 객체 안전하게 얻기
            guard let memoryToDelete = currentSavedDay.timetables[timetableIndex].memory else {
                print("ℹ️ 삭제할 메모가 없습니다.")
                // 캐시/UI 갱신은 해야 할 수도 있음
                self.memoryCache[artist.name] = nil
                self.historyCollectionView.reloadData()
                return
            }
            
            // 3) 사용자 확인 (선택) — 즉시 삭제 원하면 이 블록을 건너뛰어도 됩니다.
            let alert = UIAlertController(
                title: "추억 삭제",
                message: "\(artist.name)의 추억을 삭제하시겠어요?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
                // 4) SwiftData에서 안전하게 삭제
                if let ctx = memoryToDelete.modelContext {
                    ctx.delete(memoryToDelete)
                    do {
                        try ctx.save()
                        print("✅ \(artist.name)의 추억 삭제 완료 (SwiftData)")
                    } catch {
                        print("🚨 SwiftData 저장 오류: \(error)")
                    }
                } else if let ctx = currentSavedDay.modelContext {
                    // memoryToDelete.modelContext가 없는 드문 경우에 대비
                    ctx.delete(memoryToDelete)
                    do { try ctx.save() } catch { print("🚨 save error: \(error)") }
                } else {
                    print("🚨 모델 컨텍스트를 찾을 수 없어 삭제를 수행하지 못했습니다.")
                }
                
                // 5) 로컬 반영 및 UI 갱신
                // relationship이 cascade/optional이라면 SwiftData가 nil로 처리할 수 있지만
                currentSavedDay.timetables[timetableIndex].memory = nil
                self.memoryCache[artist.name] = nil
                self.updateForSelectedDay(dayKey: self.selectedDayKey)
            })
            
            // present alert
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
        section.interGroupSpacing = 12 // 셀과 셀 사이의 간격
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

extension HistoryDetailViewController: UICollectionViewDelegate {
    // (셀 선택 시 동작이 필요하면 여기에 구현)
}

extension HistoryDetailViewController: MemoryEditDelegate {

    func memoryDidSave(for artistName: String, dayKey: String) {
        print("🔄 Memory saved for \(artistName) on \(dayKey). Refreshing...")
        // 저장이 완료되었으므로 데이터 새로고침
        // 현재 선택된 날짜와 저장된 날짜가 같을 경우에만 즉시 새로고침
        if dayKey == self.selectedDayKey {
             updateForSelectedDay(dayKey: dayKey)
        }
        // 또는 다른 방식으로 UI 업데이트 (예: 해당 셀만 업데이트)
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
