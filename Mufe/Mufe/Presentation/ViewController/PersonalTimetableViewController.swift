//
//  PersonalTimetableViewController.swift
//  Mufe
//
//  Created by 신혜연 on 6/10/25.
//

import UIKit
import SnapKit
import Then

final class PersonalTimetableViewController: UIViewController {
    
    var selectedFestival: Festival?
    
    var timetables: [Timetable] = [] {
        didSet {
            collectionView.reloadData()
            updateCollectionViewHeight()
            updateRunningTime()
        }
    }
    
    private var collectionViewHeightConstraint: Constraint?
    
    private let recommendLabel = UILabel().then {
        $0.text = "이 공연은 어때요?"
        $0.customFont(.f2xl_Bold)
        $0.textColor = .gray00
    }
    
    private let runningTimeLabel = UILabel().then {
        $0.customFont(.flg_Medium)
        $0.textColor = .gray40
    }
    
    private let mufeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "mufe")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 343, height: 201)
        layout.minimumLineSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .grayBg
        cv.register(TimetableCell.self, forCellWithReuseIdentifier: TimetableCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    // Buttons
    private let buttonBackgroundView = UIImageView().then {
        $0.image = UIImage(named: "buttonBackground")
        $0.isUserInteractionEnabled = true
    }

    private let leftButton = UIButton().then {
        $0.setTitle("수정하기", for: .normal)
        $0.setTitleColor(.gray60, for: .normal)
        $0.titleLabel?.customFont(.flg_SemiBold)
        $0.backgroundColor = .gray90
        $0.layer.cornerRadius = 16
    }

    private let rightButton = UIButton().then {
        $0.setTitle("완료하기", for: .normal)
        $0.setTitleColor(.gray00, for: .normal)
        $0.titleLabel?.customFont(.flg_SemiBold)
        $0.backgroundColor = .primary50
        $0.layer.cornerRadius = 16
    }

    private lazy var buttonStackView = UIStackView(arrangedSubviews: [leftButton, rightButton]).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setAction()
        
        updateRunningTime()
    }
    
    private func setStyle() {
        view.backgroundColor = .grayBg
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setUI() {
        view.addSubviews(recommendLabel, runningTimeLabel, mufeImageView, collectionView, buttonBackgroundView)
        buttonBackgroundView.addSubview(buttonStackView)
    }
    
    private func setLayout() {
        recommendLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(86)
            $0.leading.equalToSuperview().offset(16)
        }
        
        runningTimeLabel.snp.makeConstraints {
            $0.top.equalTo(recommendLabel.snp.bottom).offset(4)
            $0.leading.equalTo(recommendLabel)
        }
        
        mufeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(54)
            $0.trailing.equalToSuperview().inset(16)
            $0.size.equalTo(119)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(mufeImageView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(buttonBackgroundView.snp.top)
        }
        
        // Buttons
        buttonBackgroundView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(101)
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func setAction() {
        leftButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(didTapComplete), for: .touchUpInside)
    }
    
    @objc private func didTapComplete() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            let tabBar = HomeTabBarController()
            window.rootViewController = tabBar
            window.makeKeyAndVisible()
            
            if let homeVC = tabBar.viewControllers?.first(where: { $0 is HomeViewController }) as? HomeViewController {
                homeVC.updateState(.beforeFestival)
                tabBar.selectedIndex = 0
            }
        }
    }
    
    @objc private func didTapEdit() {
        // TODO: 수정하기 버튼 로직 구현
        navigationController?.popViewController(animated: true)
    }
    
    private func updateCollectionViewHeight() {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let itemHeight = layout?.itemSize.height ?? 201
        let lineSpacing = layout?.minimumLineSpacing ?? 0
        
        let itemCount = timetables.count
        
        guard itemCount > 0 else {
            collectionViewHeightConstraint?.update(offset: 0)
            view.layoutIfNeeded()
            return
        }
        
        let totalHeight = CGFloat(itemCount) * itemHeight + CGFloat(itemCount - 1) * lineSpacing
        
        collectionViewHeightConstraint?.update(offset: totalHeight)
        view.layoutIfNeeded()
    }
    
    private func updateRunningTime() {
        let uniqueArtists = Set(timetables.map { $0.artistName })
        let totalMinutes = timetables.reduce(0) { $0 + $1.runningTime }
        
        updateRunningTimeLabel(count: uniqueArtists.count, minutes: totalMinutes)
    }
    
    func updateRunningTimeLabel(count: Int, minutes: Int) {
        runningTimeLabel.text = "총 \(count)개, \(minutes)분"
    }
}

extension PersonalTimetableViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timetables.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimetableCell.identifier, for: indexPath) as? TimetableCell else {
            return UICollectionViewCell()
        }
        
        let timetable = timetables[indexPath.item]
        cell.configure(with: timetable)
        return cell
    }
}

extension PersonalTimetableViewController: UICollectionViewDelegate {
    
}
