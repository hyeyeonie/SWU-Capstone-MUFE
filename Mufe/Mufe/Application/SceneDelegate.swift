//
//  SceneDelegate.swift
//  Mufe
//
//  Created by 신혜연 on 5/14/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
#if DEBUG
        deleteAllData()
#endif
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let homeTabBarController = HomeTabBarController()
        
        let window = UIWindow(windowScene: windowScene)
        // ⭐️ 2. UINavigationController 없이, TabBarController를 바로 rootViewController로 설정합니다.
        window.rootViewController = homeTabBarController
        window.overrideUserInterfaceStyle = .dark
        window.makeKeyAndVisible()
        self.window = window
    }
    
#if DEBUG
    func deleteAllData() {
        // 중앙 관리자를 통해 DB 작업 공간(context)을 가져옵니다.
        let context = SwiftDataManager.shared.context
        do {
            // DB에 저장된 모든 SavedFestival 데이터를 삭제하라고 명령합니다.
            // SavedFestival을 지우면, 연결된 SavedTimetable도 자동으로 함께 삭제됩니다.
            try context.delete(model: SavedFestival.self)
            print("🗑️ 모든 저장된 데이터 삭제 완료.")
        } catch {
            print("🚨 데이터 삭제 실패: \(error)")
        }
    }
#endif
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

