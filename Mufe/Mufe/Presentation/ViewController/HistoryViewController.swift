//
//  HistoryViewController.swift
//  Mufe
//
//  Created by 신혜연 on 10/1/25.
//

import UIKit
import SnapKit
import Then
import SwiftData

final class HistoryViewController: UIViewController {
    
    // MARK: - Properties
    
    private var savedFestivals: [SavedFestival] = []
    private var originalFestivals: [Festival] = []
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().then {
        $0.text = "추억"
        $0.customFont(.f2xl_Bold)
        $0.textColor = .gray00
        $0.textAlignment = .left
    }
    
    private let emptyView = emptyFestivalView().then {
        $0.setContentText("아직 간 페스티벌이 없어요\n공연을 보고 추억을 남겨보세요!")
        $0.setMufeImage(.historyEmpty)
        $0.setImageSize(width: 160, height: 140)
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
        view.addSubviews(titleLabel, timetableTabView, emptyView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.leading.equalToSuperview().inset(16)
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
    
    private func setAction() {
        timetableTabView.didSelectFestival = { [weak self] festivalName, allSavedFestivals in
            guard let self = self else { return }
            
            print("HistoryVC에서 \(festivalName) 셀이 선택되었습니다.")
            
            let detailVC = HistoryDetailViewController()
            
            guard let originalFestival = self.originalFestivals.first(where: { $0.name == festivalName }) else {
                print("🚨 원본 페스티벌 데이터를 찾지 못했습니다: \(festivalName)")
                return
            }
            
             detailVC.festival = originalFestival
             detailVC.allSavedDays = allSavedFestivals
            
            
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    private func updateViewState() {
        let today = Calendar.current.startOfDay(for: Date())

        let savedFormatter = DateFormatter()
        savedFormatter.dateFormat = "yyyy.MM.dd"
        savedFormatter.locale = Locale(identifier: "ko_KR")
        savedFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        let grouped = Dictionary(grouping: savedFestivals) { $0.festivalName }

        let filtered = grouped.mapValues { days in
            days.filter { festivalDay in
                let trimmedStartDate = festivalDay.startDate.trimmingCharacters(in: .whitespacesAndNewlines)
                guard let festivalStartDate = savedFormatter.date(from: String(trimmedStartDate.prefix(10))) else {
                    print("🚨 날짜 파싱 실패: \(festivalDay.startDate)")
                    return false
                }
                
                let dayOffset = Int(festivalDay.selectedDay.components(separatedBy: CharacterSet.decimalDigits.inverted).first ?? "1") ?? 1
                
                guard let actualDate = Calendar.current.date(byAdding: .day, value: dayOffset - 1, to: festivalStartDate) else { return false }
                
                let day = Calendar.current.startOfDay(for: actualDate)
                return day < today
            }
        }

        let pastFestivalsOnly = filtered.filter { !$0.value.isEmpty }
        let orderedFestivalNames = pastFestivalsOnly.keys.sorted()

        if pastFestivalsOnly.isEmpty {
            emptyView.isHidden = false
            timetableTabView.isHidden = true
        } else {
            emptyView.isHidden = true
            timetableTabView.isHidden = false
            timetableTabView.configure(with: pastFestivalsOnly, orderedKeys: orderedFestivalNames)
        }
    }
    
    private func loadSavedData() {
        do {
            let sortDescriptor = SortDescriptor(\SavedFestival.startDate, order: .forward)
            let descriptor = FetchDescriptor<SavedFestival>(sortBy: [sortDescriptor])
            
            self.savedFestivals = try SwiftDataManager.shared.context.fetch(descriptor)
            
            print("📚 HistoryVC: \(savedFestivals.count)개의 저장된 페스티벌을 불러왔습니다. (시작 날짜 순 정렬)")
            updateViewState()
        } catch {
            print("🚨 페스티벌 데이터 불러오기 실패: \(error)")
        }
    }
    
    private func loadOriginalFestivalData() {
        self.originalFestivals = DummyFestivalData.festivals
    }
}
