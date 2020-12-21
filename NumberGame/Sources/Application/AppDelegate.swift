//
//  AppDelegate.swift
//  NumberGame
//
//  Created by 윤중현 on 2020/12/17.
//

import UIKit

@main class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Application Lifecycle

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.configureAppearance()
    return true
  }

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role
    )
  }


  // MARK: Configuring

  private func configureAppearance() {
    UIView.appearance().backgroundColor = .systemBackground
  }
}
