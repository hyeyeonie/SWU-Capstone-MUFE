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
        let homeTabItem = UITabBarItem(
            title: "홈",
            image: UIImage(resource: .unselectedHome).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .selectedHome).withRenderingMode(.alwaysOriginal)
        )
        homeVC.tabBarItem = homeTabItem
        let homeNav = UINavigationController(rootViewController: homeVC)

        // 시간표 탭
        let timetableVC = TimetableViewController()
        let timetableTabItem = UITabBarItem(
            title: "시간표",
            image: UIImage(resource: .unselectedTimetable).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .selectedTimetable).withRenderingMode(.alwaysOriginal)
        )
        timetableVC.tabBarItem = timetableTabItem
        let timetableNav = UINavigationController(rootViewController: timetableVC)

        // 추억 탭
        let memoryVC = HistoryViewController()
        let memoryTabItem = UITabBarItem(
            title: "추억",
            image: UIImage(resource: .unselectedMemory).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .selectedMemory).withRenderingMode(.alwaysOriginal)
        )
        memoryVC.tabBarItem = memoryTabItem
        let memoryNav = UINavigationController(rootViewController: memoryVC)
        
        self.viewControllers = [homeNav, timetableNav, memoryNav]
    }
}
