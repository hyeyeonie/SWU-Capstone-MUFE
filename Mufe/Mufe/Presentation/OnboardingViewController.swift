//
//  OnboardingViewController.swift
//  Mufe
//
//  Created by 신혜연 on 5/27/25.
//

import UIKit

import SnapKit
import Then

class OnboardingViewController: UIViewController {

    // MARK: - Properties
    
    private var selectedDateItem: DateItem?
    private var selectedFestival: Festival?
    
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
    private let loadingView = LoadingView()
    
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
            nextButton.isHidden = !(currentStep == .timeSelection || currentStep == .artistSelection)
            
            updateContentViewForCurrentStep()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
    }

    // MARK: - UI Setting
    
    private func setStyle() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = .grayBg
        currentStep = .festivalSelection
        loadingView.isHidden = true
        loadingView.alpha = 0
    }
    
    private func setUI() {
        view.addSubviews(
            backButton,
            progressBar,
            titleLabel,
            scrollView,
            nextButton,
            loadingView
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
            $0.bottom.equalTo(nextButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(53)
        }
        
        loadingView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        
        print("Added \(viewToShow) to contentView")
    }
    
    private func setDelegate() {
        selectFestivalView.delegate = self
        selectDateView.delegate = self

        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        guard let previousStep = currentStep.previous() else {
            print("첫 단계라 뒤로 갈 수 없음")
            return
        }
        currentStep = previousStep
    }
    
    @objc private func didTapNextButton() {
        guard let nextStep = currentStep.next() else {
            
            showLoadingView()
            
            // currentStep이 마지막 단계인 경우 -> GPT API 호출 후 결과 화면으로 이동
            Task {
                do {
                    guard let preference = makePreference(),
                          let selectedFestival = selectedFestival else {
                        print("사용자 설정 또는 페스티벌 정보 누락")
                        hideLoadingView()
                        return
                    }
                    
                    print("🎯 사용자 선택 정보: \(preference)")
                    
                    // 1. GPT API 호출해서 Timetable 받아오기
                    let timetables = try await GetInfoService.shared.fetchFestivalTimetable(preference: preference, festival: selectedFestival)
                    
                    // 2. 결과 화면 VC 생성 및 데이터 전달
                    let personalVC = PersonalTimetableViewController()
                    personalVC.selectedFestival = selectedFestival
                    personalVC.timetables = timetables
                    
                    let nav = UINavigationController(rootViewController: personalVC)
                    nav.overrideUserInterfaceStyle = .dark
                    
                    // 3. 메인 윈도우의 rootViewController 변경 (애니메이션 포함)
                    if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let sceneDelegate = scene.delegate as? SceneDelegate,
                       let window = sceneDelegate.window {
                        UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                            window.rootViewController = nav
                        })
                    }
                    
                } catch {
                    print("타임테이블 불러오기 실패: \(error)")
                    // 필요하면 에러 알림 UI 추가
                }
                
                hideLoadingView()
            }
            
            return
        }
        
        // 다음 스텝이 artistSelection일 때 UI 업데이트
        if nextStep == .artistSelection,
           let selectedDate = selectedDateItem,
           let selectedFestival = selectedFestival {
            
            let artistsForDay = selectedFestival.artistSchedule[selectedDate.day] ?? []
            
            selectArtistView.configure(day: selectedDate.day, date: selectedDate.date)
            selectArtistView.updateArtists(artistsForDay)
        }
        
        currentStep = nextStep
    }

    
    private func makePreference() -> Preference? {
        // 선택한 페스티벌과 일자 확인
        guard let festival = selectedFestival,
              let dateItem = selectedDateItem else {
            return nil
        }
        
        // artistSchedule의 key 배열에서 선택된 날짜의 인덱스를 찾음
        let sortedDates = festival.artistSchedule.keys.sorted() // 정렬 보장 필요 시
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
        selectDateView.configure(with: festival)
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

private extension OnboardingViewController {
    
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
