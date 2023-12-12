//
//  SceneDelegate.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/10/2023.
//

import UIKit
import ESTabBarController_swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let tabBarController = ESTabBarController()
        let v1 = HomeViewController(viewModel: HomeViewModel())
        let v2 = WatchListViewController(viewModel: WatchListViewModel())
        let v3 = PortfolioViewController(viewModel: PortfolioViewModel())
        let v4 = SettingViewController(viewModel: SettingViewModel())
        v1.tabBarItem = ESTabBarItem.init(title: "", image: UIImage(named: "ic_chart"), selectedImage: UIImage(named: "ic_chart_fill"))
        v2.tabBarItem = ESTabBarItem.init(title: "", image: UIImage(named: "ic_star"), selectedImage: UIImage(named: "ic_star_fill"))
        v3.tabBarItem = ESTabBarItem.init(title: "", image: UIImage(named: "ic_briefcase"), selectedImage: UIImage(named: "ic_briefcase_fill"))
        v4.tabBarItem = ESTabBarItem.init(title: "", image: UIImage(named: "ic_user"), selectedImage: UIImage(named: "ic_user_fill"))
        
        tabBarController.viewControllers = [v1, v2, v3, v4]
        let nav = UINavigationController(rootViewController: tabBarController)
        tabBarController.title = "Example"
        
        nav.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }

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
