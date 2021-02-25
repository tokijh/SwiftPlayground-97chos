//
//  CoreDataService.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/24.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol: class {
  func fetch<T>(_:NSFetchRequest<T>) -> [T]
  var context: NSManagedObjectContext? { get }
}

class CoreDataService: CoreDataServiceProtocol {

  static let shared = CoreDataService()
  var context: NSManagedObjectContext? = nil

  private init() {
    
  }


  // MARK: CoreData

  func saveContext() -> Bool {
    guard let context = self.context else { return false }
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        return false
      }
    }
    return true
  }

  
  // MARK: Functions

  func fetch<ScoreMO>(_ fetchRequest: NSFetchRequest<ScoreMO>) -> [ScoreMO] {
    guard let context = self.context else {
      return []
    }
    do {
      let result = try context.fetch(fetchRequest)
      return result
    } catch {
      return []
    }
  }
}
