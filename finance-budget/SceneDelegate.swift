//
//  SceneDelegate.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 31.05.2021.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    // FIXME: доделать таб бар
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        let revenueViewController = RevenueViewController()
        let categoriesViewController = PurchasesCategoriesViewController()
        let navigationController = UINavigationController(rootViewController: categoriesViewController)
        let graphicsViewController = GraphicsViewController()
        
        [revenueViewController, navigationController, graphicsViewController].forEach {
            tabBarController.addChild($0)
        }
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
