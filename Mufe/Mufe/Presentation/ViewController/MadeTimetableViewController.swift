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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        addTarget()
        setInit()
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
            
            let button = DaySelectionButton()
            button.configure(with: DayItem(title: dayKey, date: day.date))
            button.addTarget(self, action: #selector(dayButtonTapped(_:)), for: .touchUpInside)
            
            daySelectionStackView.addArrangedSubview(button)
            dayButtons.append(button)
        }
        
        updateContentForSelectedDate()
    }
    
    private func updateContentForSelectedDate() {
        dayButtons.forEach { $0.isSelected = ($0.dayTitle.text == selectedDateItem.day) }

        let stageGroups = festival.artistSchedule[selectedDateItem.day] ?? []

        if stageGroups.isEmpty {
            timetableView.isHidden = true
            emptyView.isHidden = false
        } else {
            timetableView.isHidden = false
            emptyView.isHidden = true
            timetableView.configure(with: stageGroups)
        }
    }
    
    // MARK: - Action Handlers
    
    @objc private func didTapBackButton() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
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
