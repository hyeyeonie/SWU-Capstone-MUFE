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
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
        
        $0.backgroundColor = .grayBg
    }

    private let contentView = UIView()
    
    private let selectFestivalView = SelectFestivalView()
    private let selectDateView = SelectDateView()
    private let selectTimeView = SelectTimeView()
    private let selectArtistView = SelectArtistView()
    
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
        
        print("backButton isUserInteractionEnabled: \(backButton.isUserInteractionEnabled)")
    }

    // MARK: - UI Setting
    
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
            $0.height.equalTo(562)
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
            let personalVC = PersonalTimetableViewController()
            personalVC.selectedFestival = self.selectedFestival
            let nav = UINavigationController(rootViewController: personalVC)
            nav.overrideUserInterfaceStyle = .dark
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = scene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                UIView.transition(with: window, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                    window.rootViewController = nav
                })
            }
            
            return
        }
        
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
