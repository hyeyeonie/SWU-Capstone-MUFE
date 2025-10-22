//
//  OnboardingViewController.swift
//  Mufe
//
//  Created by 신혜연 on 5/27/25.
//

import UIKit

import SnapKit
import Then
import SwiftData

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var selectedDateItem: DateItem?
    private var selectedFestival: Festival?
    private var savedFestivals: [SavedFestival] = []
    
    // MARK: - UI Components
    
    private let backButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = .gray00
    }
    
    private let progressBar = ProgressBarView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .gray00
        $0.customFont(CustomUIFont.f2xl_Bold)
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .red
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        
        $0.backgroundColor = .grayBg
    }
    
    private let contentView = UIView()
    
    private let selectFestivalView = SelectFestivalView()
    private let selectDateView = SelectDateView()
    private let selectTimeView = SelectTimeView()
    private let selectArtistView = SelectArtistView()
    
    private let buttonBackgroundView = UIImageView().then {
        $0.image = UIImage(named: "buttonBackground")
    }
    
    private let nextButton = UIButton().then {
        $0.backgroundColor = .primary50
        $0.setTitle("다음으로", for: .normal)
        $0.setTitleColor(.gray00, for: .normal)
        $0.titleLabel?.customFont(.flg_SemiBold)
        $0.layer.cornerRadius = 16
        
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 8
        $0.layer.shadowOpacity = 0.4
        $0.layer.masksToBounds = false
    }
    
    var selectedFestivalName: String = "2025 뷰티풀민트라이프"
    var currentStep: FestivalProgressStep = .festivalSelection {
        didSet {
            progressBar.progress = currentStep.progress
            titleLabel.attributedText = currentStep.attributedTitle(with: selectedFestivalName, customFont: CustomUIFont.f2xl_Bold)
            
            let shouldHideButton = !(currentStep == .timeSelection || currentStep == .artistSelection)
            nextButton.isHidden = shouldHideButton
            buttonBackgroundView.isHidden = shouldHideButton
            
            if shouldHideButton {
                scrollView.snp.remakeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(32)
                    $0.horizontalEdges.equalToSuperview().inset(16)
                    $0.bottom.equalToSuperview().inset(16)
                }
            } else {
                scrollView.snp.remakeConstraints {
                    $0.top.equalTo(titleLabel.snp.bottom).offset(32)
                    $0.horizontalEdges.equalToSuperview().inset(16)
                    $0.bottom.equalTo(nextButton.snp.top).offset(-16)
                }
            }
            
            if currentStep == .artistSelection {
                nextButton.setTitle("완료", for: .normal)
                
                let hasSelection = selectArtistView.hasSelectedArtists
                nextButton.isEnabled = hasSelection
                nextButton.backgroundColor = hasSelection ? .primary50 : .gray70
                
            } else if currentStep == .timeSelection {
                nextButton.setTitle("다음으로", for: .normal)
                
                nextButton.isEnabled = true
                nextButton.backgroundColor = .primary50
            }
            
            updateContentViewForCurrentStep()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSavedData()
        
        setUI()
        setLayout()
        setDelegate()
        setStyle()
    }
    
    // MARK: - UI Setting
    
    private func loadSavedData() {
        do {
            let descriptor = FetchDescriptor<SavedFestival>()
            self.savedFestivals = try SwiftDataManager.shared.context.fetch(descriptor)
        } catch {
            print("🚨 Onboarding에서 페스티벌 데이터 불러오기 실패: \(error)")
        }
    }
    
    private func setStyle() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .grayBg
        currentStep = .festivalSelection
    }
    
    private func setUI() {
        view.addSubviews(
            backButton,
            progressBar,
            titleLabel,
            scrollView,
            buttonBackgroundView,
            nextButton
        )
        scrollView.addSubview(contentView)
    }
    
    private func setLayout() {
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
            $0.leading.equalToSuperview().offset(20)
            $0.size.equalTo(24)
        }
        
        progressBar.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        buttonBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(buttonBackgroundView.snp.bottom).offset(-24)
            $0.height.equalTo(53)
        }
    }
    
    private func updateContentViewForCurrentStep() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let viewToShow: UIView
        
        switch currentStep {
        case .festivalSelection:
            viewToShow = selectFestivalView
        case .dateSelection:
            viewToShow = selectDateView
        case .timeSelection:
            viewToShow = selectTimeView
        case .artistSelection:
            viewToShow = selectArtistView
        }
        
        viewToShow.isUserInteractionEnabled = true
        contentView.addSubview(viewToShow)
        
        viewToShow.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.setContentOffset(.zero, animated: false)
    }
    
    private func setDelegate() {
        selectFestivalView.delegate = self
        selectDateView.delegate = self
        selectArtistView.delegate = self
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        if let previousStep = currentStep.previous() {
            currentStep = previousStep
            return
        }
        
        // 루트 화면으로 갈지, 그냥 pop할지 구분
        if let nav = navigationController, nav.viewControllers.first != self {
            // navigation stack 안에서 push된 경우
            nav.popViewController(animated: true)
        } else if presentingViewController != nil {
            // 모달로 present된 경우
            dismiss(animated: true)
        } else {
            // 정말 루트일 때만 앱 루트로 이동
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
    }
    
    @objc private func didTapNextButton() {
        if currentStep == .artistSelection {
            
            guard let preference = makePreference(),
                  let selectedFestival = self.selectedFestival,
                  let selectedDateItem = self.selectedDateItem else {
                return
            }
            
            let selectedArtists = self.selectArtistView.getSelectedArtistNames()
            let existingSavedDays = self.savedFestivals.filter { $0.festivalName == selectedFestival.name }
            
            let madeVC = MadeTimetableViewController()
            
            madeVC.festival = selectedFestival
            madeVC.selectedDateItem = selectedDateItem
            madeVC.selectedArtistNames = selectedArtists
            madeVC.timetablePreference = preference
            madeVC.isFromHome = false
            
            madeVC.allSavedDays = existingSavedDays

            self.navigationController?.pushViewController(madeVC, animated: true)
            
        }else if let nextStep = currentStep.next() {
            if nextStep == .artistSelection,
               let selectedDate = selectedDateItem,
               let selectedFestival = selectedFestival {
                
                let artistsForDay = selectedFestival.artistSchedule[selectedDate.day] ?? []
                
                selectArtistView.configure(day: selectedDate.day, date: selectedDate.date)
                selectArtistView.updateArtists(artistsForDay)
            }
            
            currentStep = nextStep
        }
    }
    
    
    private func makePreference() -> Preference? {
        // 선택한 페스티벌과 일자
        guard let festival = selectedFestival,
              let dateItem = selectedDateItem else {
            return nil
        }
        
        // 선택된 날짜의 인덱스
        let sortedDates = festival.artistSchedule.keys.sorted()
        guard sortedDates.firstIndex(of: dateItem.day) != nil else {
            return nil
        }
        
        // 선택한 시간
        guard let (entryTime, exitTime) = selectTimeView.selectedTime(for: dateItem.day) else {
            return nil
        }
        
        // 선택한 아티스트
        let favoriteArtists = selectArtistView.getSelectedArtistNames()
        
        return Preference(
            selectedFestival: festival.name,
            selectedDay: dateItem.day,
            entryTime: entryTime,
            exitTime: exitTime,
            favoriteArtist: favoriteArtists
        )
    }
}

extension OnboardingViewController: FestivalSelectionDelegate {
    func didSelectFestival(_ festival: Festival) {
        selectedFestival = festival
        selectedFestivalName = festival.name
        
        // 1. 현재 선택한 페스티벌에 대해 저장된 모든 시간표를 찾습니다.
        let savedForThisFestival = savedFestivals.filter { $0.festivalName == festival.name }
        
        // 2. ⭐️⭐️⭐️ 핵심 수정 ⭐️⭐️⭐️
        // 저장된 날짜("1일차", "2일차") 문자열에서 숫자만 추출하여 [Int] 배열로 만듭니다.
        let madeDayIndices: [Int] = savedForThisFestival.compactMap {
            // "1일차" -> "1" -> 1
            let dayString = $0.selectedDay.replacingOccurrences(of: "일차", with: "")
            return Int(dayString)
        }
        
        // 3. SelectDateView의 configure 함수에 정확한 타입으로 데이터를 전달합니다.
        selectDateView.configure(with: festival, madeDays: madeDayIndices)
        
        currentStep = .dateSelection
    }
}

extension OnboardingViewController: SelectDateViewDelegate {
    func didSelectDate(_ dateItem: DateItem) {
        selectedDateItem = dateItem
        selectTimeView.updateItems([dateItem])
        currentStep = .timeSelection
    }
}

extension OnboardingViewController: SelectArtistViewDelegate {
    func didChangeArtistSelection(hasSelection: Bool) {
        // SelectArtistView로부터 신호를 받으면 버튼 상태를 업데이트합니다.
        nextButton.isEnabled = hasSelection
        nextButton.backgroundColor = hasSelection ? .primary50 : .gray70 // 상태에 따라 색상 변경
    }
}
