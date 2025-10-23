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
    var savedFestival: SavedFestival?
    var allSavedDays: [SavedFestival] = []
    var isFromCellSelection: Bool = false
    var isFromHome: Bool = false
    
    var onAddNewTimetableTapped: (() -> Void)?
    
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
    
    private let timetableView = MadeTimetableView()
    private let emptyView = MadeTimetableEmptyView()
    private let loadingView = LoadingView()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        addTarget()
        setInit()
        
        print("📦 MadeVC에 전달된 모든 날짜 정보: \(allSavedDays.map { $0.selectedDay })")
        print("받은 festival: \(festival?.name ?? "없음")")
        print("받은 date: \(selectedDateItem?.day ?? "없음")")
        print("받은 timetables: \(timetables.count)개")
    }
    
    private func convertTimetablesToArtistInfo(_ timetables: [Timetable]) -> [ArtistInfo] {
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
        
        let groupedByStage = Dictionary(grouping: timetables) {
            return artistStageMap[$0.artistName] ?? "분류되지 않은 스테이지"
        }
        
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
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        loadingView.isHidden = true
        loadingView.alpha = 0
    }
    
    private func setUI() {
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
        
        SwiftDataManager.shared.deleteSavedFestival(festivalName: festivalName, day: dayToDelete) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    print("\(festivalName) \(dayToDelete) 타임테이블 삭제 완료.")
                    self?.allSavedDays.removeAll(where: { $0.festivalName == festivalName && $0.selectedDay == dayToDelete })
                    
                    if let newSelectedDay = self?.allSavedDays.first {
                        self?.selectedDateItem = DateItem(day: newSelectedDay.selectedDay, date: newSelectedDay.selectedDate, isMade: true)
                        self?.updateContentForSelectedDate()
                    } else {
                        self?.navigationController?.popToRootViewController(animated: true)
                        if let tabBar = self?.view.window?.rootViewController as? HomeTabBarController {
                            tabBar.selectedIndex = 1
                        }
                    }
                } else {
                    print("🚨 \(festivalName) \(dayToDelete) 타임테이블 삭제 실패.")
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
        dayButtons.forEach { $0.isSelected = ($0.dayTitle.text == selectedDateItem.day) }
        
        if let savedDataForThisDay = allSavedDays.first(where: { $0.selectedDay == selectedDateItem.day }) {

            let timetables = savedDataForThisDay.timetables.map { saved in
                Timetable(artistName: saved.artistName, imageName: saved.artistImage, location: saved.location, startTime: saved.startTime, endTime: saved.endTime, runningTime: saved.runningTime, script: "")
            }
            
            let finalArtistInfo = convertTimetablesToArtistInfo(timetables)
            timetableView.isHidden = false
            emptyView.isHidden = true
            timetableView.configure(with: finalArtistInfo)
            
        } else {
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
        
        modalView.onDenyButtonTapped = { [weak self] in
            guard let self = self else { return }
            
            self.dismissModal(modalView)
            
            let initialTimetables = self.createTimetablesFromSelectedArtists()
            let newSavedFestival = self.saveTimetablesToDatabase(with: initialTimetables)
            
            self.timetables = initialTimetables
            self.savedFestival = newSavedFestival
            self.isFromCellSelection = true
            self.updateContentForSelectedDate()
        }
        
        modalView.onAcceptButtonTapped = { [weak self] in
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
                        
                        let existingSavedDays = self?.allSavedDays.filter { $0.festivalName == selectedFestival.name }
                        personalVC.existingSavedDays = existingSavedDays ?? []
                        
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
        
        for stageInfo in stageGroups {
            for artist in stageInfo.artists {
                if selectedArtistNames.contains(artist.name) {
                    let timetable = Timetable(
                        artistName: artist.name,
                        imageName: artist.image,
                        location: stageInfo.location,
                        startTime: artist.startTime,
                        endTime: artist.endTime,
                        runningTime: artist.duration,
                        script: "직접 선택한 아티스트예요."
                    )
                    timetables.append(timetable)
                }
            }
        }
        return timetables.sorted { $0.startTime < $1.startTime }
    }
    
    private func saveTimetablesToDatabase(with timetables: [Timetable]) -> SavedFestival? {
        guard let festival = self.festival,
              let dateItem = self.selectedDateItem else {
            print("Error: 저장할 정보가 부족합니다.")
            return nil
        }
        
        let savedTimetables: [SavedTimetable] = timetables.map { timetable in
            let originalArtistInfo = festival.artistSchedule[dateItem.day]?
                .first { stage in stage.artists.contains(where: { $0.name == timetable.artistName }) }
            let stage = originalArtistInfo?.stage ?? "알 수 없는 스테이지"
            
            return SavedTimetable(from: timetable, artistImage: timetable.imageName, stage: stage)
        }
        
        let newSavedFestival = SavedFestival(
            festival: festival,
            selectedDateItem: dateItem,
            timetables: savedTimetables
        )
        
        SwiftDataManager.shared.context.insert(newSavedFestival)
        print("💾 \(newSavedFestival.festivalName) 타임테이블 저장 완료! (AI 추천 없음)")
        
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
        if isFromHome {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if let presentingVC = self.presentingViewController {
            presentingVC.dismiss(animated: true) {
                self.selectTimetableTab()
            }
            return
        }
        
        if let nav = self.navigationController {
            nav.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.selectTimetableTab()
            }
            return
        }
        
        selectTimetableTab()
    }
    
    private func selectTimetableTab() {
        if let tabBar = self.view.window?.rootViewController as? HomeTabBarController {
            tabBar.selectedIndex = 0
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

extension MadeTimetableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (self.navigationController?.viewControllers.count ?? 0) > 1
    }
}
