//
//  TimetableViewController.swift
//  Mufe
//
//  Created by 신혜연 on 10/1/25.
//

import UIKit
import SnapKit
import Then
import SwiftData

final class TimetableViewController: UIViewController {
    
    private var savedFestivals: [SavedFestival] = []
    private var originalFestivals: [Festival] = []
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "시간표"
        $0.customFont(.f2xl_Bold)
        $0.textColor = .gray00
        $0.textAlignment = .left
    }
    
    private let addButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.filled()
        
        let attrs: [NSAttributedString.Key: Any] = [
            .font: CustomUIFont.fsm_SemiBold.font,
            .foregroundColor: UIColor.gray00
        ]
        config.attributedTitle = AttributedString("추가하기", attributes: AttributeContainer(attrs))
        
        let plusImage = UIImage(systemName: "plus")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .regular))
        config.image = plusImage
        config.imagePlacement = .leading
        config.imagePadding = 4
        
        config.baseBackgroundColor = .primary50
        config.cornerStyle = .capsule
        
        $0.configuration = config
        $0.clipsToBounds = true
    }
    
    private let emptyView = emptyFestivalView().then {
        $0.setContentText("페스티벌 시간표를 만들어볼까요?")
    }
    
    private let timetableTabView = TimetableTabView()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSavedData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOriginalFestivalData()
        
        setStyle()
        setUI()
        setLayout()
        setAction()
    }
    
    // MARK: - Setting Methods
    
    private func setStyle() {
        view.backgroundColor = .grayBg
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUI() {
        view.addSubviews(titleLabel, addButton, timetableTabView, emptyView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().inset(16)
        }
        
        addButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(201)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        timetableTabView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions

    private func setAction() {
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        timetableTabView.didSelectFestival = { [weak self] selectedSavedFestival in
            guard let self = self else { return }
            
            // ⭐️ 3. 수정된 로직 전체
            
            // a. DB에서 가져온 savedFestivals 배열에서 일치하는 객체를 다시 한번 확인합니다.
            guard let saved = self.savedFestivals.first(where: { $0.id == selectedSavedFestival.id }) else {
                print("🚨 일치하는 저장된 페스티벌을 찾지 못했습니다.")
                return
            }
            
            // b. '원본' Festival 배열에서 이름이 같은 객체를 찾습니다.
            guard let originalFestival = self.originalFestivals.first(where: { $0.name == saved.festivalName }) else {
                print("🚨 원본 페스티벌 데이터를 찾지 못했습니다: \(saved.festivalName)")
                return
            }
            
            let madeVC = MadeTimetableViewController()
            
            // c. UI 구성을 위해 '원본' Festival 객체를 전달합니다.
            madeVC.festival = originalFestival
            
            // d. 시간표 내용을 채우기 위해 '저장된' SavedFestival 객체를 전달합니다.
            madeVC.savedFestival = saved
            
            // e. '저장된' 날짜를 기준으로 초기 선택 날짜를 설정합니다.
            madeVC.selectedDateItem = DateItem(
                day: saved.selectedDay,
                date: saved.selectedDate,
                isMade: true
            )
            
            madeVC.isFromCellSelection = true
            self.navigationController?.pushViewController(madeVC, animated: true)
        }
    }
    
    @objc private func didTapAddButton() {
        let onboardingVC = OnboardingViewController()
        
        let nav = UINavigationController(rootViewController: onboardingVC)
        nav.modalPresentationStyle = .fullScreen
        nav.setNavigationBarHidden(true, animated: false)
        
        self.present(nav, animated: true)
    }
    
    private func updateViewState() {
        if savedFestivals.isEmpty {
            emptyView.isHidden = false
            timetableTabView.isHidden = true
        } else {
            emptyView.isHidden = true
            timetableTabView.isHidden = false
            // ⭐️ TimetableTabView가 [SavedFestival] 데이터를 받도록 수정해야 합니다.
            timetableTabView.configure(with: savedFestivals)
        }
    }
    
    private func loadSavedData() {
        do {
            // 데이터베이스에서 모든 SavedFestival 데이터를 가져오라는 '요청서(Descriptor)'를 만듭니다.
            let descriptor = FetchDescriptor<SavedFestival>()

            // 중앙 관리자를 통해 요청서를 실행하고, 결과를 받아와 배열에 저장합니다.
            self.savedFestivals = try SwiftDataManager.shared.context.fetch(descriptor)

            print("📚 \(savedFestivals.count)개의 저장된 페스티벌을 불러왔습니다.")
            updateViewState()
        } catch {
            print("🚨 페스티벌 데이터 불러오기 실패: \(error)")
        }
    }
    
    private func loadOriginalFestivalData() {
            self.originalFestivals = DummyFestivalData.festivals
    }
}
