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
    
    private let backButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = .white
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
        
        $0.backgroundColor = .black
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
            
            // TODO: 수정
            switch currentStep {
            case .festivalSelection:
                selectFestivalView.isHidden = false
                selectDateView.isHidden = true
                selectTimeView.isHidden = true
                selectArtistView.isHidden = true
                
            case .dateSelection:
                selectFestivalView.isHidden = true
                selectDateView.isHidden = false
                selectTimeView.isHidden = true
                selectArtistView.isHidden = true
                
            case .timeSelection:
                selectFestivalView.isHidden = true
                selectDateView.isHidden = true
                selectTimeView.isHidden = false
                selectArtistView.isHidden = true
                
            case .artistSelection:
                selectFestivalView.isHidden = true
                selectDateView.isHidden = true
                selectTimeView.isHidden = true
                selectArtistView.isHidden = false
            }
            
            selectTimeView.updateItems([
                DateItem(day: "1일차", date: "1월 7일 토요일", enterTime: "13:00", leaveTime: "21:00")
            ])
            
            selectArtistView.configure(day: "1일차", date: "1월 7일 토요일")
            
            selectArtistView.updateArtists([
                ArtistInfo(
                    stage: "STAGE 1",
                    location: "88잔디마당",
                    artists: [
                        (name: "잔나비", image: UIImage(named: "artistImg")),
                        (name: "혁오", image: UIImage(named: "artistImg")),
                        (name: "적재", image: UIImage(named: "artistImg")),
                        (name: "NCT", image: UIImage(named: "artistImg")),
                        (name: "재현", image: UIImage(named: "artistImg")),
                        (name: "유우시", image: UIImage(named: "artistImg"))
                    ]
                ),
                ArtistInfo(
                    stage: "STAGE 2",
                    location: "SK핸드볼경기장",
                    artists: [
                        (name: "10cm", image: UIImage(named: "artistImg")),
                        (name: "새소년", image: UIImage(named: "artistImg")),
                        (name: "볼빨간사춘기", image: UIImage(named: "artistImg"))
                    ]
                )
            ])
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
    }

    // MARK: - UI Setting
    
    private func setStyle() {
        view.backgroundColor = .black
        currentStep = .artistSelection
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
        contentView.addSubviews(selectFestivalView, selectDateView, selectTimeView, selectArtistView)
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
        
        selectFestivalView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        selectDateView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        selectTimeView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        selectArtistView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-24)
            $0.height.equalTo(53)
        }
    }
}
