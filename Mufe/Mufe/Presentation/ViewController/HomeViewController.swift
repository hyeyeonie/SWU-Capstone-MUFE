//
//  HomeViewController.swift
//  Mufe
//
//  Created by 신혜연 on 8/14/25.
//

import UIKit

import SnapKit
import Then

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
    
    private var selectedFestival: Festival?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
        
        if let firstFestival = DummyFestivalData.festivals.first {
            setFestival(firstFestival)
            
            // DdayFestivalView에 오늘 날짜 기준으로 공연 시간 전달
            if let day1Stages = firstFestival.artistSchedule["1일차"] {
                var times: [(ArtistSchedule, ArtistInfo)] = []
                for stage in day1Stages {
                    for artist in stage.artists {
                        times.append((artist, stage))
                    }
                }
                dDayFestivalView.updateFestivalTimes(times)
            }
            
            // 오늘 날짜 기준으로 상태 업데이트
            updateFestivalState()
        }
        
        updateView()
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
    }
    
    private func updateView() {
        emptyFestivalView.isHidden = currentState != .emptyFestival
        beforeFestivalView.isHidden = currentState != .beforeFestival
        dDayFestivalView.isHidden = currentState != .dDayFestival
        afterFestivalView.isHidden = currentState != .afterFestival
        
        switch currentState {
        case .beforeFestival:
            titleLabel.isHidden = false
            
            if let festival = selectedFestival {
                let dDayText = FestivalUtils.calculateDDay(from: festival.startDate)
                let text = "두근두근!\n페스티벌이 \(dDayText) 남았어요."
                
                let attributedText = NSMutableAttributedString(string: text)
                if let range = text.range(of: dDayText) {
                    let nsRange = NSRange(range, in: text)
                    attributedText.addAttribute(.font, value: CustomUIFont.fxl_Bold.font, range: nsRange)
                }
                
                titleLabel.attributedText = attributedText
            } else {
                titleLabel.attributedText = nil
            }

        case .dDayFestival:
            titleLabel.isHidden = false
            let artistName = "아사달"
            let text = "\(artistName)의 공연\n재밌게 즐기고 계신가요?"
            
            let attributedText = NSMutableAttributedString(string: text)
            
            if let range = text.range(of: artistName) {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttribute(.font, value: CustomUIFont.fxl_Bold.font, range: nsRange)
            }
            
            titleLabel.attributedText = attributedText
            
        default:
            titleLabel.isHidden = true
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateFestivalState()
        }
    }
    
    @objc private func updateFestivalState() {
        guard let festival = selectedFestival else { return }
        let now = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        if let start = formatter.date(from: "\(festival.startDate) 00:00"),
           let end = formatter.date(from: "\(festival.endDate) 23:59") {
            if now < start {
                updateState(.beforeFestival)
            } else if now >= start && now <= end {
                updateState(.dDayFestival)
            } else {
                updateState(.afterFestival)
            }
        }
    }

    deinit {
        timer?.invalidate()
    }
    
    func updateState(_ newState: HomeViewState) {
        currentState = newState
    }
    
    func setFestival(_ festival: Festival) {
        selectedFestival = festival
        beforeFestivalView.setFestival(festival)
        updateView()
    }
}

extension HomeViewController: EmptyFestivalViewDelegate {
    func didTapRegisterFestButton() {
        let registerVC = OnboardingViewController()
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

#Preview {
    HomeViewController()
}
