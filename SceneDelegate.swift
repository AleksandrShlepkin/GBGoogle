//
//  SceneDelegate.swift
//  GBGoogleMap
//
//  Created by Mac on 24.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        let appWindows = UIWindow(frame: UIScreen.main.bounds)
        appWindows.windowScene = windowsScene
        let navigation = UINavigationController()
        coordinator = AppCoordinator(navigator: navigation)
        coordinator?.start()
        appWindows.rootViewController = navigation
        appWindows.makeKeyAndVisible()
        window = appWindows
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        self.window?.viewWithTag(221122)?.removeFromSuperview()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window!.frame
        blurEffectView.tag = 221122

        self.window?.addSubview(blurEffectView)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
        self.window?.viewWithTag(221122)?.removeFromSuperview()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

