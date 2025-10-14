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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        addTarget()
        setInit()
        
        print("✅ 받은 festival: \(festival?.name ?? "없음")")
        print("✅ 받은 date: \(selectedDateItem?.day ?? "없음")")
        print("✅ 받은 timetables: \(timetables.count)개")
    }
    
    private func convertTimetablesToArtistInfo(_ timetables: [Timetable]) -> [ArtistInfo] {
        // 1. "아티스트-스테이지"와 "아티스트-이미지" 정보를 담을 지도를 미리 만듭니다.
        var artistStageMap: [String: String] = [:]
        var artistImageMap: [String: String] = [:] // ⭐️ 이미지 정보를 담을 지도 추가

        if let stageGroups = festival.artistSchedule[selectedDateItem.day] {
            for stageInfo in stageGroups {
                for artist in stageInfo.artists {
                    artistStageMap[artist.name] = stageInfo.stage
                    artistImageMap[artist.name] = artist.image // ⭐️ 아티스트 이름과 이미지 짝 저장
                }
            }
        }

        // 2. 스테이지 이름으로 그룹핑합니다.
        let groupedByStage = Dictionary(grouping: timetables) {
            return artistStageMap[$0.artistName] ?? "분류되지 않은 스테이지"
        }

        // 3. 그룹핑된 데이터를 화면에 필요한 [ArtistInfo] 형태로 최종 변환합니다.
        let artistInfoArray = groupedByStage.map { (stageName, timetablesForStage) -> ArtistInfo in

            // ⭐️ 이 부분이 수정된 핵심입니다.
            let artists = timetablesForStage.map { timetable -> ArtistSchedule in
                // 지도에서 아티스트 이미지를 찾아오고, 없으면 기본 이미지를 사용합니다.
                let imageName = artistImageMap[timetable.artistName] ?? "defaultArtistImage" // "defaultArtistImage"는 placeholder 이미지 이름으로 변경하세요.

                // 찾은 이미지 정보로 ArtistSchedule을 안전하게 생성합니다.
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
        
        if timetables.isEmpty {
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

          // ⭐️ 핵심 로직: AI가 만들어준 timetables 데이터가 있는지 먼저 확인합니다.
          if !timetables.isEmpty {
              // 데이터가 있다면, "최종 결과 화면" 모드입니다.
              let finalArtistInfo = convertTimetablesToArtistInfo(timetables)

              if finalArtistInfo.isEmpty {
                  timetableView.isHidden = true
                  emptyView.isHidden = false
              } else {
                  timetableView.isHidden = false
                  emptyView.isHidden = true
                  timetableView.configure(with: finalArtistInfo)
              }

          } else {
              // 데이터가 없다면, "초기 선택 화면" 모드입니다. (기존 로직)
              let stageGroups = festival.artistSchedule[selectedDateItem.day] ?? []
              let filteredStageGroups = stageGroups.map { stage in
                  // ... (기존 필터링 코드와 동일)
                  let filteredArtists = stage.artists.filter { selectedArtistNames.contains($0.name) }
                  return ArtistInfo(stage: stage.stage, location: stage.location, artists: filteredArtists)
              }.filter { !$0.artists.isEmpty }

              if filteredStageGroups.isEmpty {
                  timetableView.isHidden = true
                  emptyView.isHidden = false
              } else {
                  timetableView.isHidden = false
                  emptyView.isHidden = true
                  timetableView.configure(with: filteredStageGroups)
              }
          }
    }
    
    private func showModal() {
        let modalView = ModalView(frame: self.view.bounds)
        
        // 모달 버튼 콜백 설정
        modalView.onDenyButtonTapped = { [weak self] in
            self?.dismissModal(modalView)
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
    
    private func dismissModal(_ modalView: ModalView) {
        UIView.animate(withDuration: 0.25, animations: {
            modalView.alpha = 0
        }, completion: { _ in
            modalView.removeFromSuperview()
        })
    }
    
    // MARK: - Action Handlers
    
    @objc private func didTapBackButton() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            let homeTabBar = HomeTabBarController()
            
            UIView.transition(with: window,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: {
                window.rootViewController = homeTabBar
            })
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

// MARK: - Preview

#Preview {
    // --- 1. 더미 데이터 생성 ---
    let dummyArtistSchedule1 = ArtistSchedule(name: "Tuesday Beach Club", image: "artistImg1", startTime: "11:50", endTime: "12:20")
    let dummyArtistSchedule2 = ArtistSchedule(name: "Lazy Afternoon", image: "artistImg2", startTime: "12:30", endTime: "13:00")
    let dummyArtistInfo1 = ArtistInfo(stage: "STAGE 1", location: "SOUND PLANET", artists: [dummyArtistSchedule1, dummyArtistSchedule2])
    
    let dummyArtistSchedule3 = ArtistSchedule(name: "Night Owls", image: "artistImg3", startTime: "13:10", endTime: "13:40")
    let dummyArtistSchedule4 = ArtistSchedule(name: "Star Chasers", image: "artistImg4", startTime: "13:40", endTime: "14:20")
    let dummyArtistInfo2 = ArtistInfo(stage: "STAGE 2", location: "SUNSHINE", artists: [dummyArtistSchedule3, dummyArtistSchedule4])
    
    let dummyFestival = Festival(
        imageName: "festivalImg",
        name: "Summer Fest",
        startDate: "6.11",
        endDate: "6.12",
        location: "Seoul",
        // "2일차"는 비어있는 상태를 테스트하기 위해 일부러 비워둠
        artistSchedule: ["1일차": [dummyArtistInfo1, dummyArtistInfo2]],
        days: [
            FestivalDay(dayOfWeek: "금", date: "6.11"),
            FestivalDay(dayOfWeek: "토", date: "6.12"),
        ]
    )
    
    // --- 2. 뷰 컨트롤러 생성 및 데이터 주입 ---
    let vc = MadeTimetableViewController()
    vc.festival = dummyFestival
    
    // "1일차"를 먼저 보여주도록 설정
    //    vc.selectedDateItem = DateItem(day: "1일차", date: "6.11", isMade: false)
    
    // 만약 "2일차"(빈 화면)를 먼저 보고 싶다면 아래 코드로 교체
    vc.selectedDateItem = DateItem(day: "2일차", date: "6.12", isMade: false)
    
    return vc
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
