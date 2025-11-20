//
//  HomeViewController.swift
//  Mufe
//
//  Created by 신혜연 on 8/14/25.
//

import UIKit

import SnapKit
import Then
import SwiftData

enum HomeViewState {
    case emptyFestival
    case beforeFestival
    case dDayFestival
    case afterFestival
}

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private var timer: Timer?
    
    private var currentState: HomeViewState = .emptyFestival {
        didSet { updateView() }
    }
    
    private var savedFestivals: [SavedFestival] = []
    private var selectedFestival: SavedFestival?
    private let dismissedAfterFestivalKey = "dismissedAfterFestivalName"
    
    // MARK: - UI Components
    
    private let emptyFestivalView = EmptyFestivalView()
    private let beforeFestivalView = BeforeFestivalView()
    private let dDayFestivalView = DdayFestivalView()
    private let afterFestivalView = AfterFestivalView()
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .gray20
        $0.customFont(.title_Medium)
        $0.textAlignment = .left
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedData()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        view.backgroundColor = .grayBg
    }
    
    private func setUI() {
        view.addSubviews(emptyFestivalView, beforeFestivalView, dDayFestivalView, afterFestivalView,
                         titleLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(74)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        [beforeFestivalView, dDayFestivalView].forEach { view in
            view.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom)
                $0.horizontalEdges.bottom.equalToSuperview()
            }
        }
        
        [emptyFestivalView, afterFestivalView].forEach { view in
            view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func setDelegate() {
        emptyFestivalView.delegate = self
        beforeFestivalView.delegate = self
        afterFestivalView.delegate = self
    }
    
    private func updateView() {
        emptyFestivalView.isHidden = currentState != .emptyFestival
        beforeFestivalView.isHidden = currentState != .beforeFestival
        dDayFestivalView.isHidden = currentState != .dDayFestival
        afterFestivalView.isHidden = currentState != .afterFestival
        titleLabel.isHidden = (currentState == .emptyFestival || currentState == .afterFestival)
        tabBarController?.tabBar.isHidden = (currentState == .afterFestival)
        
        guard let festival = selectedFestival else { return }
        
        afterFestivalView.setFestival(festival)
        
        switch currentState {
        case .beforeFestival:
            let allDaysForThisFestival = savedFestivals.filter { $0.festivalName == festival.festivalName }
            beforeFestivalView.setFestivals(allDaysForThisFestival)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            
            guard let festivalStartDate = formatter.date(from: festival.startDate),
                  let dayOffsetString = festival.selectedDay.components(separatedBy: CharacterSet.decimalDigits.inverted).first,
                  let dayOffset = Int(dayOffsetString),
                  let thisSavedDayDate = Calendar.current.date(byAdding: .day, value: dayOffset - 1, to: festivalStartDate) else {
                
                titleLabel.text = "페스티벌이\n다가오고 있어요!"
                break
            }
            
            let savedDateString = formatter.string(from: thisSavedDayDate)
            let dDayText = FestivalUtils.getDaysRemainingString(from: savedDateString)
            
            let text = "두근두근!\n페스티벌이 \(dDayText) 남았어요."
            let attributedText = NSMutableAttributedString(string: text)
            if let range = text.range(of: dDayText) {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttributes([
                    .font: CustomUIFont.title_SemiBold.font,
                    .foregroundColor: UIColor.gray00
                ], range: nsRange)
            }
            titleLabel.attributedText = attributedText
            
        case .dDayFestival:
            let todayTimetables = festival.timetables.sorted { $0.startTime < $1.startTime }
            
            let now = Date()
            let calendar = Calendar.current
            let todayStart = calendar.startOfDay(for: now)
            
            let currentPerformance = todayTimetables.first { timetable in
                let startComponents = DateComponents(hour: Int(timetable.startTime.prefix(2)), minute: Int(timetable.startTime.suffix(2)))
                let endComponents = DateComponents(hour: Int(timetable.endTime.prefix(2)), minute: Int(timetable.endTime.suffix(2)))
                
                guard let start = calendar.date(byAdding: startComponents, to: todayStart),
                      let end = calendar.date(byAdding: endComponents, to: todayStart) else { return false }
                
                return now >= start && now < end
            }
            
            let nextPerformance = todayTimetables.first { timetable in
                let startComponents = DateComponents(hour: Int(timetable.startTime.prefix(2)), minute: Int(timetable.startTime.suffix(2)))
                guard let start = calendar.date(byAdding: startComponents, to: todayStart) else { return false }
                return now < start
            }
            
            let artistName: String
            if let current = currentPerformance {
                artistName = current.artistName
            } else if let next = nextPerformance {
                artistName = next.artistName
            } else {
                artistName = "오늘"
            }
            
            let text = "\(artistName)의 공연\n재밌게 즐기고 계신가요?"
            let attributedText = NSMutableAttributedString(string: text)
            if let range = text.range(of: artistName) {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttributes([
                    .font: CustomUIFont.title_SemiBold.font,
                    .foregroundColor: UIColor.gray00,
                ], range: nsRange)
            }
            titleLabel.attributedText = attributedText
            dDayFestivalView.updateFestivalTimes(todayTimetables)
            
        default:
            titleLabel.text = ""
        }
    }
    
    private func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.determineCurrentState()
        }
    }
    
    private func loadSavedData() {
        do {
            let descriptor = FetchDescriptor<SavedFestival>()
            let fetchedFestivals = try SwiftDataManager.shared.context.fetch(descriptor)
            self.savedFestivals = fetchedFestivals.sorted {
                if $0.startDate != $1.startDate {
                    return $0.startDate < $1.startDate
                }
                let day1 = Int($0.selectedDay.components(separatedBy: CharacterSet.decimalDigits.inverted).first ?? "0") ?? 0
                let day2 = Int($1.selectedDay.components(separatedBy: CharacterSet.decimalDigits.inverted).first ?? "0") ?? 0
                return day1 < day2
            }
            print("📚 홈: \(savedFestivals.count)개의 저장된 페스티벌을 불러왔습니다.")
            determineCurrentState()
        } catch {
            print("🚨 홈: 페스티벌 데이터 불러오기 실패: \(error)")
            currentState = .emptyFestival
        }
    }
    
    private func determineCurrentState() {
        guard !savedFestivals.isEmpty else {
            selectedFestival = nil
            currentState = .emptyFestival
            return
        }
        
        let now = Date()
        let todayStart = Calendar.current.startOfDay(for: now)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let getActualDate = { (festival: SavedFestival) -> Date? in
            guard let festivalStartDate = formatter.date(from: festival.startDate),
                  let dayOffsetString = festival.selectedDay.components(separatedBy: CharacterSet.decimalDigits.inverted).first,
                  let dayOffset = Int(dayOffsetString) else {
                return nil
            }
            return Calendar.current.date(byAdding: .day, value: dayOffset - 1, to: festivalStartDate)
        }
        
        let todaySavedFestival = savedFestivals.first { festival in
            guard let savedDate = getActualDate(festival) else { return false }
            return Calendar.current.isDate(savedDate, inSameDayAs: todayStart)
        }
        
        if let dDayFestival = todaySavedFestival {
            self.selectedFestival = dDayFestival
            self.currentState = .dDayFestival
            return
        }
        
        let upcomingSavedDays = savedFestivals.compactMap { festival -> (SavedFestival, Date)? in
            guard let savedDate = getActualDate(festival) else { return nil }
            if savedDate > todayStart {
                return (festival, savedDate)
            }
            return nil
        }.sorted { $0.1 < $1.1 }
        
        if let (nextFestival, _) = upcomingSavedDays.first {
            self.selectedFestival = nextFestival
            self.currentState = .beforeFestival
            return
        }

        if let lastFestival = savedFestivals.last {
            let dismissedName = UserDefaults.standard.string(forKey: dismissedAfterFestivalKey)
            if lastFestival.festivalName == dismissedName {
                self.selectedFestival = nil
                self.currentState = .emptyFestival
                return
            }
            self.selectedFestival = lastFestival
            self.currentState = .afterFestival
            return
        }
        
        self.selectedFestival = nil
        self.currentState = .emptyFestival
    }
    
    private func convertSavedFestivalToFestival(_ savedFestival: SavedFestival) -> Festival {
        let groupedByStage = Dictionary(grouping: savedFestival.timetables) { $0.stage }
        let artistInfos = groupedByStage.map { (stageName, timetablesForStage) -> ArtistInfo in
            let artistSchedules = timetablesForStage.map {
                ArtistSchedule(
                    name: $0.artistName,
                    image: $0.artistImage,
                    startTime: $0.startTime,
                    endTime: $0.endTime
                )
            }
            
            return ArtistInfo(
                stage: stageName,
                location: timetablesForStage.first?.location ?? "",
                artists: artistSchedules.sorted { $0.startTime < $1.startTime }
            )
        }
        
        let artistScheduleDict: [String: [ArtistInfo]] = [
            savedFestival.selectedDay: artistInfos.sorted { $0.stage < $1.stage }
        ]
        
        let days = [FestivalDay(dayOfWeek: "", date: savedFestival.selectedDate)]
        
        return Festival(
            imageName: savedFestival.festivalImageName,
            name: savedFestival.festivalName,
            startDate: savedFestival.startDate,
            endDate: savedFestival.endDate,
            location: savedFestival.location,
            artistSchedule: artistScheduleDict,
            days: days
        )
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func updateState(_ newState: HomeViewState) {
        currentState = newState
    }
}

extension HomeViewController: EmptyFestivalViewDelegate {
    func didTapRegisterFestButton() {
        let registerVC = OnboardingViewController()
        registerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

extension HomeViewController: DateSelectionDelegate {
    func didSelectDate(_ dateItem: DateItem) {
        guard let currentFestival = selectedFestival else {
            print("🚨 HomeVC: 선택된 페스티벌 정보가 없어 화면을 전환할 수 없습니다.")
            return
        }
        
        let allDaysForThisFestival = savedFestivals.filter { $0.festivalName == currentFestival.festivalName }
        
        let madeVC = MadeTimetableViewController()
        
        if let originalFestival = DummyFestivalData.festivals.first(where: { $0.name == currentFestival.festivalName }) {
            madeVC.festival = originalFestival
        } else {
            print("🚨 HomeVC: 원본 페스티벌 데이터를 찾지 못했습니다. SavedFestival을 변환합니다.")
            
            madeVC.festival = self.convertSavedFestivalToFestival(currentFestival)
        }
        
        madeVC.allSavedDays = allDaysForThisFestival
        madeVC.selectedDateItem = dateItem
        madeVC.isFromCellSelection = true
        
        if let savedDay = allDaysForThisFestival.first(where: { $0.selectedDay == dateItem.day }) {
            madeVC.timetables = savedDay.timetables.map { saved in
                Timetable(
                    artistName: saved.artistName,
                    imageName: saved.artistImage,
                    location: saved.location,
                    startTime: saved.startTime,
                    endTime: saved.endTime,
                    runningTime: saved.runningTime,
                    script: ""
                )
            }
            madeVC.savedFestival = savedDay
        }
        
        madeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(madeVC, animated: true)
    }
}

extension HomeViewController: AfterFestivalViewDelegate {
    func didTapLaterButton() {
        print("AfterFestivalView: 다음에 하기 탭됨")
        if let festivalName = self.selectedFestival?.festivalName {
            UserDefaults.standard.set(festivalName, forKey: dismissedAfterFestivalKey)
        }
        self.currentState = .emptyFestival
    }
    
    func didTapCreateMemoryButton() {
        print("AfterFestivalView: 추억 남기기 탭됨")
        
        guard let selectedFestival = self.selectedFestival else {
            print("🚨 HomeVC: 선택된 페스티벌이 없어 '추억'으로 이동할 수 없습니다.")
            return
        }
        let festivalName = selectedFestival.festivalName
        
        guard let originalFestival = DummyFestivalData.festivals.first(where: { $0.name == festivalName }) else {
            print("🚨 HomeVC: 'DummyFestivalData'에서 \(festivalName)의 원본 데이터를 찾지 못했습니다.")
            return
        }
        
        let allDaysForThisFestival = self.savedFestivals.filter { $0.festivalName == festivalName }
        if allDaysForThisFestival.isEmpty {
            print("🚨 HomeVC: 'savedFestivals'에 \(festivalName)의 데이터가 없습니다.")
            return
        }

        guard let tabBar = self.tabBarController else { return }
        guard let historyNav = tabBar.viewControllers?[2] as? UINavigationController else {
            print("🚨 HomeVC: '추억' 탭의 Navigation Controller(index 2)를 찾을 수 없습니다.")
            return
        }

        if let festivalName = self.selectedFestival?.festivalName {
            UserDefaults.standard.set(festivalName, forKey: dismissedAfterFestivalKey)
        }
        
        tabBar.selectedIndex = 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let detailVC = HistoryDetailViewController()
            detailVC.festival = originalFestival
            detailVC.allSavedDays = allDaysForThisFestival
            detailVC.hidesBottomBarWhenPushed = true
            
            historyNav.popToRootViewController(animated: false)
            historyNav.pushViewController(detailVC, animated: true)

            self.currentState = .emptyFestival
        }
    }
}

#Preview {
    HomeViewController()
}
