//
//  CoreDataService.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/24.
//

import Foundation
import CoreData

class CoreDataService {

  // MARK: Initailize

  private let context: NSManagedObjectContext!

  init(context: NSManagedObjectContext) {
    self.context = context
  }


  // MARK: CoreData

  func saveContext() {
    if self.context.hasChanges {
      do {
        try self.context.save()
      } catch let error as NSError {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }


  // MARK: Functions

  func fetch<ScoreMO>(_ fetchRequest: NSFetchRequest<ScoreMO>) -> [ScoreMO] {
    do {
      let result = try self.context.fetch(fetchRequest)
      return result
    } catch {
      return []
    }
  }
}
