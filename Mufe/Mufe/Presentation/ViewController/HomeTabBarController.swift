//
//  HomeTabBarController.swift
//  Mufe
//
//  Created by 신혜연 on 8/14/25.
//

import UIKit

final class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setupTabBar()
    }
    
    private func setStyle() {
        view.backgroundColor = .grayBg
    }

    private func setupTabBar() {
        tabBar.tintColor = .primary50
        tabBar.unselectedItemTintColor = .gray60
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .grayBg
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            tabBar.barTintColor = .grayBg
        }
        
        // 홈 탭
        let homeVC = HomeViewController()
        homeVC.title = "홈" // 탭 타이틀
        let homeTabItem = UITabBarItem(
            title: "홈",
            image: UIImage(resource: .unselectedHome).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .selectedHome).withRenderingMode(.alwaysOriginal)
        )
        homeVC.tabBarItem = homeTabItem

        // 시간표 탭
        let timetableVC = TimetableViewController()
        timetableVC.title = "시간표"
        let timetableTabItem = UITabBarItem(
            title: "시간표",
            image: UIImage(resource: .unselectedTimetable).withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(resource: .selectedTimetable).withRenderingMode(.alwaysTemplate)
        )
        timetableVC.tabBarItem = timetableTabItem

        // 추억 탭
        let memoryVC = HistoryViewController()
        memoryVC.title = "추억"
        memoryVC.tabBarItem = UITabBarItem(
            title: "추억",
            image: UIImage(resource: .unselectedMemory).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .selectedMemory).withRenderingMode(.alwaysOriginal)
        )

        self.viewControllers = [homeVC, timetableVC, memoryVC]
    }
}
