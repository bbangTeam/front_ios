//
//  SceneDelegate.swift
//  Bbang
//
//  Created by 소영 on 2021/05/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let _ = (scene as? UIWindowScene) else { return }
		
		// MARK: Dark mode
		window?.overrideUserInterfaceStyle = .light
		
		let server = ServerDataOperator()
		let locationGather = LocationGather()
		let bakeryInfomanager = BakeryInfoManager(server: server, location: locationGather)
		
		if let tabBar = window?.rootViewController as? UITabBarController {
			if let homeVC = tabBar.viewControllers?.first(where: {
				$0 is HomeViewController
			}) as? HomeViewController,
			let mapSearchVC = tabBar.viewControllers?.first(where: {
				$0 is MapSearchViewController
			}) as? MapSearchViewController{
				homeVC.location = locationGather
				homeVC.server = server
				homeVC.bakeryInfo = bakeryInfomanager
				mapSearchVC.location = locationGather
				mapSearchVC.server = server
				mapSearchVC.infoManager = bakeryInfomanager
			}else {
				assertionFailure("Fail to find view controllers in tab bar")
			}
		}else {
			assertionFailure("Fail to find tab bar controller")
		}
		
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

