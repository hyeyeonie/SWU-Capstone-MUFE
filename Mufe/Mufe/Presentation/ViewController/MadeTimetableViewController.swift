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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            self.showModal()
        }
    }
    
    private func setStyle() {
        view.backgroundColor = .grayBg
    }
    
    private func setUI() {
        view.backgroundColor = .grayBg
        view.addSubviews(backButton, festivalNameLabel,
                         daySelectionStackView,
                         timetableView, emptyView)
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
            if let dotIndex = day.date.lastIndex(of: ".") {
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

        let stageGroups = festival.artistSchedule[selectedDateItem.day] ?? []
        
        let filteredStageGroups: [ArtistInfo] = stageGroups.map { stage in
            let filteredArtists = stage.artists.filter { artist in
                selectedArtistNames.contains(artist.name)
            }
            return ArtistInfo(
                stage: stage.stage,
                location: stage.location,
                artists: filteredArtists
            )
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
    
    private func showModal() {
        let modalView = ModalView(frame: self.view.bounds)
        
        // 모달 버튼 콜백 설정
        modalView.onDenyButtonTapped = { [weak self] in
            self?.dismissModal(modalView)
        }
        
        modalView.onAcceptButtonTapped = { [weak self] in
            // 추천받기 액션 처리
            self?.dismissModal(modalView)
            // 필요하면 추가 로직 실행
        }
        
        modalView.alpha = 0
        view.addSubview(modalView)
        
        UIView.animate(withDuration: 0.25) {
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
