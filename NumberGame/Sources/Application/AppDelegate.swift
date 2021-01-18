//
//  AppDelegate.swift
//  NumberGame
//
//  Created by 윤중현 on 2020/12/17.
//

import UIKit
import CoreData

@main class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: Application Lifecycle

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
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


  // MARK: CoreData

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "ScoreLogsDataModel")
    container.loadPersistentStores {
      if let error = $1 as NSError? {
        fatalError("Unresolved srror \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
}
