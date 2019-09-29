//
//  SceneDelegate.swift
//  TechTaskGitHub
//
//  Created by Arsenkin Bogdan on 9/26/19.
//  Copyright © 2019 Arsenkin Bogdan. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.windowScene = windowScene
		window?.backgroundColor = .white
		window?.makeKeyAndVisible()
		
		let navigationController = MainNavigationController()
		window?.rootViewController = navigationController
		
		let userController = UsersViewController()
		navigationController.setViewControllers([userController], animated: true)
	}

}

