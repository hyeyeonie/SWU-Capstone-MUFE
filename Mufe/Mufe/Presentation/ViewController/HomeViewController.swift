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
    
    private var currentState: HomeViewState = .emptyFestival {
        didSet { updateView() }
    }
    
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
        updateView()
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
            let remainingDays = 29
            let text = "두근두근!\n페스티벌이 \(remainingDays)일 남았어요."
            
            let attributedText = NSMutableAttributedString(string: text)
            
            if let range = text.range(of: "\(remainingDays)") {
                let nsRange = NSRange(range, in: text)
                attributedText.addAttribute(.font, value: CustomUIFont.fxl_Bold.font, range: nsRange)
            }
            
            titleLabel.attributedText = attributedText
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
    
    func updateState(_ newState: HomeViewState) {
        currentState = newState
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
