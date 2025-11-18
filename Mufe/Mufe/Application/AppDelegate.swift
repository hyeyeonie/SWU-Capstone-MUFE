//
//  AppDelegate.swift
//  Mufe
//
//  Created by 신혜연 on 5/14/25.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        NotificationManager.shared.requestNotificationPermission()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱이 켜져있을 때 알림 배너 띄우기 (기존 동일)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let identifier = response.notification.request.identifier
        print("🔔 [알림 탭] ID: \(identifier)")
        
        // 메인 탭바 컨트롤러 찾기
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = sceneDelegate.window,
              let tabBarController = window.rootViewController as? UITabBarController else {
            completionHandler()
            return
        }
        
        // 알림 종류에 따라 탭 이동
        if identifier.starts(with: "performance-") {
            print("👉 홈 화면으로 이동합니다.")
            tabBarController.selectedIndex = 0
            
        } else if identifier.starts(with: "post-festival-") {
            print("👉 추억 남기기 화면으로 이동합니다.")
            tabBarController.selectedIndex = 2
        }
        
        completionHandler()
    }
}
