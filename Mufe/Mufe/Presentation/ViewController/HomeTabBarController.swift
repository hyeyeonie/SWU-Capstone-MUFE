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
        
        // 홈 탭
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(resource: .unselectedHome).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .selectedHome).withRenderingMode(.alwaysOriginal)
        )

        // 시간표 탭
        let timetableVC = UIViewController()
        timetableVC.view.backgroundColor = UIColor.grayBg
        timetableVC.tabBarItem = UITabBarItem(
            title: "시간표",
            image: UIImage(resource: .unselectedTimetable).withRenderingMode(.alwaysTemplate),
            selectedImage: UIImage(resource: .selectedTimetable).withRenderingMode(.alwaysTemplate)
        )

        // 추억 탭
        let memoryVC = UIViewController()
        memoryVC.view.backgroundColor = UIColor.grayBg
        memoryVC.tabBarItem = UITabBarItem(
            title: "추억",
            image: UIImage(resource: .unselectedMemory).withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(resource: .selectedMemory).withRenderingMode(.alwaysOriginal)
        )

        self.viewControllers = [homeVC, timetableVC, memoryVC]
    }
}
