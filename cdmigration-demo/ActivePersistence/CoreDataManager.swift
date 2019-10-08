//
//  CoreDataManager.swift
//  cdmigration-demo
//
//  Created by Jin He on 10/5/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
  static let shared = CoreDataManager()
  
  private var persistentContainer: NSPersistentContainer
  
  private let env: Environment
  
  lazy var viewContext: NSManagedObjectContext = {
    let context = self.persistentContainer.viewContext
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    context.automaticallyMergesChangesFromParent = true
    context.shouldDeleteInaccessibleFaults = true
    context.name = "\(self.env.rawValue) environment viewContext: \(context.hashValue)"
    return context
  }()
  
  lazy private var containerPath: URL? = {
    return URL(string: "")
  }()
  
  lazy private var pathForSqliteStore: String? = {
    return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last?.absoluteString.removingPercentEncoding
  }()
  
  func newBackgroundContext() -> NSManagedObjectContext {
    let context = self.persistentContainer.newBackgroundContext()
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    context.name = "\(self.env) environment backgroundContext: \(context.hashValue)"
    return context
  }
  
  func performBackgroundTask(block: @escaping (NSManagedObjectContext) -> Void) {
    self.persistentContainer.performBackgroundTask(block)
  }
  
  func loadPersistentContainer() {
    let startTime = DispatchTime.now()
    self.persistentContainer.loadPersistentStores { (description, error) in
      let endTime = DispatchTime.now()
      let timeInterval = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1000000000
      if let err = error {
        fatalError("Failed to load persistent container of type under \(self.env) environment: \(err)")
      } else {
        print("PersistentContainer loaded in \(timeInterval) seconds under \(self.env) environment")
        print(self.pathForSqliteStore!)
      }
    }
  }
  
  /// Convenient helper method to save everything on the viewContext when user suddenly closes the app.
  func saveViewContext() {
    if self.viewContext.hasChanges {
      do {
        try self.viewContext.save()
      } catch let err {
        fatalError("Unresolved error \(err.localizedDescription)")
      }
    }
  }
  
  private init(_ env: Environment = .development) {
    self.env = env
    let container = NSPersistentContainer(name: "Model")
    switch env {
    case .development:
      break
    case .test:
      let description = NSPersistentStoreDescription()
      description.type = NSInMemoryStoreType
      description.shouldAddStoreAsynchronously = false
      container.persistentStoreDescriptions = [description]
    case .production:
      break
    }
    self.persistentContainer = container
    super.init()
  }
}
