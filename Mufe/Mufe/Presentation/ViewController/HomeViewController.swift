//
//  HomeViewController.swift
//  Mufe
//
//  Created by 신혜연 on 8/14/25.
//

import UIKit

import SnapKit
import Then

final class HomeViewController: UIViewController {
    
    // MARK: - UI Components

    private let emptyFestivalView = EmptyFestivalView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        setDelegate()
    }
    
    // MARK: - Setup Methods
    
    private func setStyle() {
        view.backgroundColor = .grayBg
    }
    
    private func setUI() {
        view.addSubviews(emptyFestivalView)
    }
    
    private func setLayout() {
        emptyFestivalView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        emptyFestivalView.delegate = self
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
