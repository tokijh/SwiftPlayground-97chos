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
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = GameListViewController()
    window?.windowScene = scene
    window?.makeKeyAndVisible()
  }
}
