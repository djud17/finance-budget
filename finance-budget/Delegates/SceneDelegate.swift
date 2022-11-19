//
//  SceneDelegate.swift
//  finance-budget
//
//  Created by Давид Тоноян  on 31.05.2021.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        let revenueViewController = RevenueViewController()
        revenueViewController.tabBarItem.title = "Доходы"
        revenueViewController.tabBarItem.image = UIImage(named: "money")
        
        let categoriesViewController = PurchasesCategoriesViewController()
        let navigationController = UINavigationController(rootViewController: categoriesViewController)
        navigationController.tabBarItem.title = "Расходы"
        navigationController.tabBarItem.image = UIImage(named: "receipt")
        
        let graphicsViewController = GraphicsViewController()
        graphicsViewController.tabBarItem.title = "График"
        graphicsViewController.tabBarItem.image = UIImage(named: "graph")
        
        [revenueViewController, navigationController, graphicsViewController].forEach {
            tabBarController.addChild($0)
        }
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
