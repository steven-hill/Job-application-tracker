//
//  SceneDelegate.swift
//  JobApplicationTracker
//
//  Created by Steven Hill on 04/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coreDataCoordinator: CoreDataCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard
            let _ = (scene as? UIWindowScene),
            let navigationController = window?.rootViewController as? UINavigationController,
            let homeViewController = navigationController.children[0] as? HomeViewController
        else { return }
        let coreDataCoordinator = CoreDataCoordinator()
        
        self.coreDataCoordinator = coreDataCoordinator
        homeViewController.delegate = coreDataCoordinator
    }
}

