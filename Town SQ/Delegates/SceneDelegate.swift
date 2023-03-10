//
//  SceneDelegate.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit
import AWSCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`
        window?.backgroundColor = Color.background
        switch Progress.state {
        case .InviteCodeVerified:
            let vc = SignupViewController()
            vc.path = .InviteCode
            showNav([vc])
        case .PhoneCodeSent:
            let codeVC = CodeViewController()
            if let phone = UserDefaults.standard.string(forKey: Constants.verificationPhone) {
                if let country = UserDefaults.standard.string(forKey: Constants.verificationCountry) {
                    codeVC.phoneNumber = country + phone
                    showNav([DemoWelcomeController(), SignupViewController(), codeVC])
                }else {
                    showNav([DemoWelcomeController()])
                }
            }else {
                showNav([DemoWelcomeController()])
            }
            
        case .PhoneVerified:
            showNav([DisplayNameViewController()])
        case .DisplayNameSet:
            showNav([DisplayNameViewController(), UsernameViewController()])
        case .UsernameSet:
            showNav([DisplayNameViewController(), UsernameViewController(), DOBViewController()])
        case .DOBSet:
            showNav([DisplayNameViewController(), UsernameViewController(), DOBViewController(), ProfilePhotoViewController()])
        case .ProfilePhotoSet:
            let tbVC = TabBarController()
            showNav([tbVC])
        case .none:
            showNav([DemoWelcomeController()])
        case .some(.None):
            showNav([DemoWelcomeController()])
        }
        
        func showNav(_ controllers: [UIViewController]) {
            let navigationController = NavigationController(rootViewController: controllers[0])
            controllers.dropFirst(1).forEach({ controller in
                navigationController.pushViewController(controller, animated: false)
            })
            if !(controllers[0] is UITabBarController) {
                navigationController.hideTopBar()
            }
            //        let navigationController = NavigationController(rootViewController: TabBarController())
            window?.rootViewController = navigationController
            window?.becomeKey()
        }
        
        if DB.UserRecord() == nil {
            DB.shared.drop(.User)
            DB.shared.drop(.Broadcast)
            DB.shared.drop(.Comment)
            showNav([DemoWelcomeController()])
        }
        
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let _ = (scene as? UIWindowScene) else { return }
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

		// Save changes in the application's managed object context when the application transitions to the background.
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}

}

