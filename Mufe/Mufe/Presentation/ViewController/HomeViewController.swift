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
    
    // MARK: - UI Components
    
    private let emptyFestivalView = EmptyFestivalView()
    private let beforeFestivalView = BeforeFestivalView()
    private let dDayFestivalView = DdayFestivalView()
    private let afterFestivalView = AfterFestivalView()
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.textColor = .gray20
        $0.customFont(.fxl_Medium)
        $0.textAlignment = .left
    }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSavedData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
        startTimer()
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
    }
    
    private func updateView() {
        emptyFestivalView.isHidden = currentState != .emptyFestival
        beforeFestivalView.isHidden = currentState != .beforeFestival
        dDayFestivalView.isHidden = currentState != .dDayFestival
        afterFestivalView.isHidden = currentState != .afterFestival
        
        titleLabel.isHidden = (currentState == .emptyFestival || currentState == .afterFestival)
        
        guard let festival = selectedFestival else { return }
        
        afterFestivalView.setFestival(festival)
        
        switch currentState {
        case .beforeFestival:
            let allDaysForThisFestival = savedFestivals.filter { $0.festivalName == festival.festivalName }
            beforeFestivalView.setFestivals(allDaysForThisFestival)
            
            let dDayText = FestivalUtils.getDaysRemainingString(from: festival.startDate)
            let text = "두근두근!\n페스티벌이 \(dDayText) 남았어요."
            let attributedText = NSMutableAttributedString(string: text)
            if let range = text.range(of: dDayText) {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttribute(.font, value: CustomUIFont.fxl_Bold.font, range: nsRange)
            }
            titleLabel.attributedText = attributedText
            
        case .dDayFestival:
            // ✨ D-Day일 때 로직 수정 ✨
            let todayTimetables = festival.timetables.sorted { $0.startTime < $1.startTime } // 시간순으로 정렬
            
            let now = Date()
            let calendar = Calendar.current
            
            // 1. ✨ 오늘 날짜의 00:00:00 시점을 기준으로 사용합니다.
            let todayStart = calendar.startOfDay(for: now)
            
            // 2. ✨ 현재 진행 중인 공연 찾기
            let currentPerformance = todayTimetables.first { timetable in
                // "HH:mm" 문자열을 DateComponents로 파싱
                let startComponents = DateComponents(hour: Int(timetable.startTime.prefix(2)), minute: Int(timetable.startTime.suffix(2)))
                let endComponents = DateComponents(hour: Int(timetable.endTime.prefix(2)), minute: Int(timetable.endTime.suffix(2)))
                
                // 오늘 날짜와 공연 시간을 합쳐서 정확한 Date 객체를 만듭니다.
                guard let start = calendar.date(byAdding: startComponents, to: todayStart),
                      let end = calendar.date(byAdding: endComponents, to: todayStart) else { return false }
                
                // 이제 날짜와 시간이 모두 정확하므로, 비교가 올바르게 동작합니다.
                return now >= start && now < end
            }
            
            // 3. ✨ (진행 중인 공연이 없다면) 가장 빨리 시작할 다음 공연 찾기
            let nextPerformance = todayTimetables.first { timetable in
                let startComponents = DateComponents(hour: Int(timetable.startTime.prefix(2)), minute: Int(timetable.startTime.suffix(2)))
                guard let start = calendar.date(byAdding: startComponents, to: todayStart) else { return false }
                return now < start
            }
            
            // 4. ✨ 우선순위에 따라 아티스트 이름 결정
            let artistName: String
            if let current = currentPerformance {
                artistName = current.artistName
            } else if let next = nextPerformance {
                artistName = next.artistName
            } else {
                artistName = "모든" // 모든 공연이 끝난 경우
            }
            
            // 5. 타이틀 업데이트
            let text = "\(artistName)의 공연\n재밌게 즐기고 계신가요?"
            let attributedText = NSMutableAttributedString(string: text)
            if let range = text.range(of: artistName) {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttribute(.font, value: CustomUIFont.fxl_Bold.font, range: nsRange)
            }
            titleLabel.attributedText = attributedText
            
            // 6. DdayFestivalView에 오늘의 전체 시간표 전달
            dDayFestivalView.updateFestivalTimes(todayTimetables)
            
        default:
            titleLabel.text = ""
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.determineCurrentState()
        }
    }
    
    private func loadSavedData() {
        do {
            let descriptor = FetchDescriptor<SavedFestival>()
            // 날짜순으로 정렬해서 가져오는 것이 좋습니다.
            self.savedFestivals = try SwiftDataManager.shared.context.fetch(descriptor).sorted { $0.startDate < $1.startDate }
            print("📚 홈: \(savedFestivals.count)개의 저장된 페스티벌을 불러왔습니다.")
            
            // 데이터를 불러온 후, 어떤 뷰를 보여줄지 결정합니다.
            determineCurrentState()
            
        } catch {
            print("🚨 홈: 페스티벌 데이터 불러오기 실패: \(error)")
            currentState = .emptyFestival
        }
    }
    
    private func determineCurrentState() {
        // 1. 저장된 페스티벌이 없으면 empty 상태
        guard !savedFestivals.isEmpty else {
            selectedFestival = nil
            currentState = .emptyFestival
            return
        }
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        // 2. 오늘 날짜에 포함되는(D-Day) 페스티벌 찾기
        let dDayFestivals = savedFestivals.filter { festival in
            guard let start = formatter.date(from: festival.startDate),
                  let end = formatter.date(from: festival.endDate) else { return false }
            // 날짜 비교를 위해 시간은 00:00:00으로 맞춤
            let todayStart = Calendar.current.startOfDay(for: now)
            return todayStart >= Calendar.current.startOfDay(for: start) && todayStart <= Calendar.current.startOfDay(for: end)
        }
        
        if let dDayFestival = dDayFestivals.first {
            self.selectedFestival = dDayFestival
            self.currentState = .dDayFestival
            return
        }
        
        // 3. 아직 시작하지 않은(다가오는) 페스티벌 찾기
        let upcomingFestivals = savedFestivals.filter { festival in
            guard let start = formatter.date(from: festival.startDate) else { return false }
            return now < start
        }
        
        if let nextFestival = upcomingFestivals.first { // 이미 날짜순으로 정렬했으므로 first가 가장 가까운 페스티벌
            self.selectedFestival = nextFestival
            self.currentState = .beforeFestival
            return
        }
        
        // 4. 모든 페스티벌이 끝난 경우 (가장 최근에 끝난 페스티벌을 기준)
        if let lastFestival = savedFestivals.last {
            self.selectedFestival = lastFestival
            self.currentState = .afterFestival
        }
    }
    
    private func convertSavedFestivalToFestival(_ savedFestival: SavedFestival) -> Festival {
        // 1. timetables를 stage 이름으로 그룹핑합니다.
        let groupedByStage = Dictionary(grouping: savedFestival.timetables) { $0.stage }
        
        // 2. 그룹핑된 데이터를 [ArtistInfo] 형태로 변환합니다.
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
        
        // 3. Festival 객체가 요구하는 [String: [ArtistInfo]] 형태로 최종 변환합니다.
        let artistScheduleDict: [String: [ArtistInfo]] = [
            savedFestival.selectedDay: artistInfos.sorted { $0.stage < $1.stage }
        ]
        
        // 4. FestivalDay 객체를 생성합니다.
        let days = [FestivalDay(dayOfWeek: "", date: savedFestival.selectedDate)]
        
        // 5. 최종 Festival 객체를 생성하여 반환합니다.
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
        
        madeVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(madeVC, animated: true)
    }
}

#Preview {
    HomeViewController()
}
