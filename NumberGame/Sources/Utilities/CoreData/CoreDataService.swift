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
  func delete(_ objectID: NSManagedObjectID) -> Bool
  func edit(_ objectID: NSManagedObjectID, name: String) -> Bool
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

  func delete(_ objectID: NSManagedObjectID) -> Bool {
    guard let context = self.context else {
      return false
    }
    let object = context.object(with: objectID)
    context.delete(object)

    do {
      try context.save()
      return true
    } catch {
      return false
    }
  }

  func edit(_ objectID: NSManagedObjectID, name: String) -> Bool {
    guard let context = self.context else {
      return false
    }
    let object = context.object(with: objectID) as? ScoreMO
    object?.playerName = name

    do {
      try context.save()
      return true
    } catch {
      return false
    }
  }
}
