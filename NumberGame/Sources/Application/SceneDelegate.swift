//
//  SceneDelegate.swift
//  NumberGame
//
//  Created by 윤중현 on 2020/12/17.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  // MARK: Properties

  var window: UIWindow?


  // MARK: Scene Lifecycle

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = scene as? UIWindowScene else { return }
    let navigationController = UINavigationController(rootViewController: GameListViewController())
    navigationController.navigationBar.prefersLargeTitles = true
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = navigationController
    self.window?.windowScene = scene
    self.window?.makeKeyAndVisible()
  }
}
