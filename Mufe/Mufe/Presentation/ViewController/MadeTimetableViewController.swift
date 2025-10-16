//
//  MadeTimetableViewController.swift
//  Mufe
//
//  Created by 신혜연 on 10/12/25.
//

import UIKit

import SnapKit
import Then

class MadeTimetableViewController: UIViewController {
    
    // MARK: - Properties
    
    var festival: Festival!
    var selectedDateItem: DateItem!
    var timetables: [Timetable] = []
    var selectedArtistNames: [String] = []
    var timetablePreference: Preference?
    var isFromCellSelection: Bool = false
    var savedFestival: SavedFestival?
    var allSavedDays: [SavedFestival] = []
    
    var onAddNewTimetableTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    private let backButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = .gray00
    }
    
    private let festivalNameLabel = UILabel().then {
        $0.textColor = .gray50
        $0.customFont(.flg_SemiBold)
    }
    
    private var dayButtons: [DaySelectionButton] = []
    
    private let daySelectionStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fill
    }
    
    private let timetableView = MadeTimetableView()
    private let emptyView = MadeTimetableEmptyView()
    private let loadingView = LoadingView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        addTarget()
        setInit()
        
        print("📦 MadeVC에 전달된 모든 날짜 정보: \(allSavedDays.map { $0.selectedDay })")
        print("✅ 받은 festival: \(festival?.name ?? "없음")")
        print("✅ 받은 date: \(selectedDateItem?.day ?? "없음")")
        print("✅ 받은 timetables: \(timetables.count)개")
    }
    
    private func convertTimetablesToArtistInfo(_ timetables: [Timetable]) -> [ArtistInfo] {
        // 1. '현재 선택된 날짜'의 스테이지 정보만으로 지도를 만듭니다.
        var artistStageMap: [String: String] = [:]
        var artistImageMap: [String: String] = [:]
        
        if let stageGroups = festival.artistSchedule[selectedDateItem.day] {
            for stageInfo in stageGroups {
                for artist in stageInfo.artists {
                    artistStageMap[artist.name] = stageInfo.stage
                    artistImageMap[artist.name] = artist.image
                }
            }
        }
        
        // 2. 스테이지 이름으로 그룹핑합니다.
        let groupedByStage = Dictionary(grouping: timetables) {
            return artistStageMap[$0.artistName] ?? "분류되지 않은 스테이지"
        }
        
        // 3. 그룹핑된 데이터를 화면 형태로 최종 변환합니다.
        let artistInfoArray = groupedByStage.map { (stageName, timetablesForStage) -> ArtistInfo in
            let artists = timetablesForStage.map { timetable -> ArtistSchedule in
                let imageName = artistImageMap[timetable.artistName] ?? "defaultArtistImage"
                return ArtistSchedule(
                    name: timetable.artistName,
                    image: imageName,
                    startTime: timetable.startTime,
                    endTime: timetable.endTime
                )
            }
            
            let location = festival.artistSchedule[selectedDateItem.day]?
                .first { $0.stage == stageName }?.location ?? "위치 정보 없음"
            
            return ArtistInfo(
                stage: stageName,
                location: location,
                artists: artists.sorted { $0.startTime < $1.startTime }
            )
        }
        
        return artistInfoArray.sorted { $0.stage < $1.stage }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isFromCellSelection, timetables.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.showModal()
            }
        }
    }
    
    private func setStyle() {
        view.backgroundColor = .grayBg
        
        loadingView.isHidden = true
        loadingView.alpha = 0
    }
    
    private func setUI() {
        view.backgroundColor = .grayBg
        view.addSubviews(backButton, festivalNameLabel,
                         daySelectionStackView,
                         timetableView, emptyView,
                         loadingView)
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
        
        timetableView.snp.makeConstraints {
            $0.top.equalTo(daySelectionStackView.snp.bottom).offset(32)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(daySelectionStackView.snp.bottom).offset(32)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func addTarget() {
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        timetableView.onDeleteButtonTapped = { [weak self] in
            self?.confirmAndDeleteCurrentTimetable()
        }
        
        emptyView.onRegisterButtonTapped = { [weak self] in
            self?.navigateToOnboarding()
        }
    }
    
    private func confirmAndDeleteCurrentTimetable() {
        let alert = UIAlertController(title: "타임테이블 삭제", message: "이 날짜의 타임테이블을 정말 삭제하시겠습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.deleteCurrentDayTimetable()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func deleteCurrentDayTimetable() {
        guard let festivalName = festival?.name,
              let dayToDelete = selectedDateItem?.day else {
            print("🚨 삭제할 페스티벌 이름 또는 날짜 정보가 부족합니다.")
            return
        }
        
        // SwiftData를 통해 해당 날짜의 SavedFestival 객체 삭제
        SwiftDataManager.shared.deleteSavedFestival(festivalName: festivalName, day: dayToDelete) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    print("✅ \(festivalName) \(dayToDelete) 타임테이블 삭제 완료.")
                    // allSavedDays 배열에서 해당 날짜 정보 제거
                    self?.allSavedDays.removeAll(where: { $0.festivalName == festivalName && $0.selectedDay == dayToDelete })
                    
                    // 삭제 후, 남아있는 다른 날짜가 있는지 확인
                    if let newSelectedDay = self?.allSavedDays.first {
                        // 다른 날짜가 있다면 그 날짜로 이동
                        self?.selectedDateItem = DateItem(day: newSelectedDay.selectedDay, date: newSelectedDay.selectedDate, isMade: true)
                        self?.updateContentForSelectedDate()
                    } else {
                        // 해당 페스티벌에 더 이상 저장된 날짜가 없다면, TimetableViewController로 돌아감
                        self?.navigationController?.popToRootViewController(animated: true)
                        if let tabBar = self?.view.window?.rootViewController as? HomeTabBarController {
                            tabBar.selectedIndex = 1 // Timetable 탭으로 이동
                        }
                    }
                } else {
                    print("🚨 \(festivalName) \(dayToDelete) 타임테이블 삭제 실패.")
                    // 삭제 실패 시 사용자에게 알림
                    let errorAlert = UIAlertController(title: "삭제 실패", message: "타임테이블 삭제에 실패했습니다. 다시 시도해주세요.", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self?.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OnboardingViewController()
        let nav = UINavigationController(rootViewController: onboardingVC)
        nav.modalPresentationStyle = .fullScreen
        nav.setNavigationBarHidden(true, animated: false)
        self.present(nav, animated: true)
    }
    
    private func setInit() {
        festivalNameLabel.text = festival.name
        
        daySelectionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dayButtons.removeAll()
        
        for (index, day) in festival.days.enumerated() {
            let dayKey = "\(index + 1)일차"
            
            let dateText: String
            if day.date.lastIndex(of: ".") != nil {
                let startIndex = day.date.index(day.date.startIndex, offsetBy: 5)
                dateText = String(day.date[startIndex...])
            } else {
                dateText = day.date
            }
            
            let button = DaySelectionButton()
            button.configure(with: DayItem(title: dayKey, date: dateText))
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            
            daySelectionStackView.addArrangedSubview(button)
            dayButtons.append(button)
        }
        
        updateContentForSelectedDate()
    }
    
    private func updateContentForSelectedDate() {
        // 1. 버튼 UI 상태 업데이트 (어떤 모드든 공통)
        dayButtons.forEach { $0.isSelected = ($0.dayTitle.text == selectedDateItem.day) }
        
        // 💡✨ 2. 핵심 로직: 현재 선택한 날짜(selectedDateItem.day)에 해당하는 저장된 데이터가 allSavedDays 배열에 있는지 확인합니다.
        if let savedDataForThisDay = allSavedDays.first(where: { $0.selectedDay == selectedDateItem.day }) {
            // ✅ 있다면, "결과 표시 모드"로 동작합니다. (예: 1일차 탭을 눌렀을 경우)
            
            // 해당 날짜의 타임테이블을 가져와 화면에 표시합니다.
            let timetables = savedDataForThisDay.timetables.map { saved in
                Timetable(artistName: saved.artistName, imageName: saved.artistImage, location: saved.location, startTime: saved.startTime, endTime: saved.endTime, runningTime: saved.runningTime, script: "")
            }
            
            let finalArtistInfo = convertTimetablesToArtistInfo(timetables)
            timetableView.isHidden = false
            emptyView.isHidden = true
            timetableView.configure(with: finalArtistInfo)
            
        } else {
            // ❌ 없다면, "선택 확인 모드"로 동작합니다. (예: 새로 만드는 2일차 탭을 눌렀을 경우)
            
            // Onboarding에서 막 선택한 아티스트 목록(selectedArtistNames)을 사용해 화면을 구성합니다.
            let stageGroups = festival.artistSchedule[selectedDateItem.day] ?? []
            let filteredStageGroups = stageGroups.map { stage in
                let filteredArtists = stage.artists.filter { selectedArtistNames.contains($0.name) }
                return ArtistInfo(stage: stage.stage, location: stage.location, artists: filteredArtists)
            }.filter { !$0.artists.isEmpty }
            
            let shouldShowEmptyView = filteredStageGroups.isEmpty
            timetableView.isHidden = shouldShowEmptyView
            emptyView.isHidden = !shouldShowEmptyView
            
            if !shouldShowEmptyView {
                timetableView.configure(with: filteredStageGroups)
            }
        }
    }
    
    private func showModal() {
        let modalView = ModalView(frame: self.view.bounds)
        
        // 모달 버튼 콜백 설정
        modalView.onDenyButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            self.dismissModal(modalView)
            
            // 1. Onboarding에서 선택한 아티스트 목록으로 [Timetable] 배열을 생성합니다.
            let initialTimetables = self.createTimetablesFromSelectedArtists()
            
            // 2. 생성된 시간표를 DB에 저장하고, 저장된 객체를 받아옵니다.
            let newSavedFestival = self.saveTimetablesToDatabase(with: initialTimetables)
            
            // 3. 현재 뷰컨트롤러의 상태를 '결과 표시 모드'로 업데이트합니다.
            self.timetables = initialTimetables
            self.savedFestival = newSavedFestival
            self.isFromCellSelection = true // 모달이 다시 뜨지 않도록 설정
            
            // 4. UI를 새로고침하여 시간표를 표시합니다.
            self.updateContentForSelectedDate()
        }
        
        modalView.onAcceptButtonTapped = { [weak self] in
            // loadingView 호출
            self?.dismissModal(modalView)
            self?.showLoadingView()
            Task {
                do {
                    guard let preference = self?.timetablePreference,
                          let selectedFestival = self?.festival else {
                        self?.hideLoadingView()
                        return
                    }
                    
                    let timetables = try await GetInfoService.shared.fetchFestivalTimetable(
                        preference: preference,
                        festival: selectedFestival
                    )
                    
                    _ = self?.selectedArtistNames
                    
                    DispatchQueue.main.async {
                        self?.hideLoadingView()
                        
                        let personalVC = PersonalTimetableViewController()
                        
                        personalVC.timetables = timetables
                        
                        personalVC.selectedFestival = selectedFestival
                        personalVC.selectedDateItem = self?.selectedDateItem
                        personalVC.timetablePreference = self?.timetablePreference
                        
                        self?.navigationController?.pushViewController(personalVC, animated: true)
                    }
                    
                } catch {
                    print("타임테이블 불러오기 실패: \(error)")
                    self?.hideLoadingView()
                }
            }
        }
        
        modalView.alpha = 0
        view.addSubview(modalView)
        
        UIView.animate(withDuration: 0.1) {
            modalView.alpha = 1
        }
    }
    
    private func createTimetablesFromSelectedArtists() -> [Timetable] {
        guard let stageGroups = festival.artistSchedule[selectedDateItem.day] else { return [] }
        
        var timetables: [Timetable] = []
        
        // 페스티벌의 모든 스테이지와 아티스트를 순회
        for stageInfo in stageGroups {
            for artist in stageInfo.artists {
                // 만약 아티스트가 사용자가 선택한 목록에 포함되어 있다면
                if selectedArtistNames.contains(artist.name) {
                    // Timetable 객체를 만들어 배열에 추가
                    let timetable = Timetable(
                        artistName: artist.name,
                        imageName: artist.image,
                        location: stageInfo.location,
                        startTime: artist.startTime,
                        endTime: artist.endTime,
                        runningTime: artist.duration, // ArtistSchedule의 duration 계산 속성 사용
                        script: "직접 선택한 아티스트예요." // 기본 스크립트
                    )
                    timetables.append(timetable)
                }
            }
        }
        // 시간순으로 정렬하여 반환
        return timetables.sorted { $0.startTime < $1.startTime }
    }
    
    // Helper 2: [Timetable] 배열을 받아 DB에 저장하고 최종 결과 화면으로 이동하는 함수
    // (PersonalTimetableViewController의 didTapComplete 로직과 거의 동일)
    private func saveTimetablesToDatabase(with timetables: [Timetable]) -> SavedFestival? {
        guard let festival = self.festival,
              let dateItem = self.selectedDateItem else {
            print("Error: 저장할 정보가 부족합니다.")
            return nil
        }
        
        // 1. [Timetable]을 DB에 저장할 [SavedTimetable] 형태로 변환
        let savedTimetables: [SavedTimetable] = timetables.map { timetable in
            let originalArtistInfo = festival.artistSchedule[dateItem.day]?
                .first { stage in stage.artists.contains(where: { $0.name == timetable.artistName }) }
            let stage = originalArtistInfo?.stage ?? "알 수 없는 스테이지"
            
            return SavedTimetable(from: timetable, artistImage: timetable.imageName, stage: stage)
        }
        
        // 2. 최종적으로 저장할 SavedFestival 객체 생성
        let newSavedFestival = SavedFestival(
            festival: festival,
            selectedDateItem: dateItem,
            timetables: savedTimetables
        )
        
        // 3. SwiftData를 통해 DB에 저장
        SwiftDataManager.shared.context.insert(newSavedFestival)
        print("💾 \(newSavedFestival.festivalName) 타임테이블 저장 완료! (AI 추천 없음)")
        
        // 4. 저장된 객체를 반환
        return newSavedFestival
    }
    
    private func dismissModal(_ modalView: ModalView) {
        UIView.animate(withDuration: 0.25, animations: {
            modalView.alpha = 0
        }, completion: { _ in
            modalView.removeFromSuperview()
        })
    }
    
    // MARK: - Action Handlers
    @objc private func didTapBackButton() {
        // 1. 모달이면 먼저 dismiss
        if let presentingVC = self.presentingViewController {
            presentingVC.dismiss(animated: true) {
                // dismiss 완료 후 TabBarController 선택
                self.selectTimetableTab()
            }
            return
        }
        
        // 2. navigation stack이면 popToRoot
        if let nav = self.navigationController {
            nav.popToRootViewController(animated: true)
            // pop 완료 후 TabBarController 선택
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.selectTimetableTab()
            }
            return
        }
        
        // 3. 루트가 TabBarController면 바로 선택
        selectTimetableTab()
    }
    
    private func selectTimetableTab() {
        if let tabBar = self.view.window?.rootViewController as? HomeTabBarController {
            tabBar.selectedIndex = 1
        }
    }
    
    
    @objc private func dayButtonTapped(_ sender: DaySelectionButton) {
        guard let dayTitle = sender.dayTitle.text,
              let dateText = sender.dayText.text else { return }
        
        if dayTitle == selectedDateItem?.day { return }
        
        selectedDateItem = DateItem(day: dayTitle, date: dateText, isMade: false)
        updateContentForSelectedDate()
    }
}

private extension MadeTimetableViewController {
    func showLoadingView() {
        loadingView.alpha = 0
        loadingView.isHidden = false
        view.bringSubviewToFront(loadingView)
        
        UIView.animate(withDuration: 0.25) {
            self.loadingView.alpha = 1
        }
    }
    
    func hideLoadingView() {
        UIView.animate(withDuration: 0.25, animations: {
            self.loadingView.alpha = 0
        }, completion: { _ in
            self.loadingView.isHidden = true
        })
    }
}
