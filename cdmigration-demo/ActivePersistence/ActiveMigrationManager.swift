//
//  ActiveMigrationManager.swift
//  cdmigration-demo
//
//  Created by sudofluff on 10/8/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation

struct ActiveMigrationManager{
  struct ActiveMigrationArchive {
    static let shared = ActiveMigrationArchive()
    
    func add(_ m: ActiveMigratable) {
      
    }
    
    func empty() {
      
    }
  }
  
  enum MigrationKey: String {
    case migrated = "Migrated"
  }
  
  /// This is an ordered list of migration files. If you don't remember what order they should be, please refer to Git or the created date on the swift file meta data on its header area.
  private let orderedListOfMigratables: [ActiveMigratable]
  
  private var pendingMigrations: [ActiveMigratable] {
    // TODO: loop through migration path files to find any pending files
    return []
  }
  
  func exec(completion: (Result<Void, Error>) -> Void) {
    if !self.pendingMigrations.isEmpty {
      do {
        try self.pendingMigrations.forEach { (m) in
          try m.perform()
          // TODO: store migrated refs in UserDefaults
          ActiveMigrationArchive.shared.add(m)
        }
        completion(.success(()))
      } catch let err {
        completion(.failure(err))
      }
    } else {
      // TODO: pretty print warning message
      print("no pending migration")
    }
  }
  
  init(orderedListOfMigratables: [ActiveMigratable]) {
    self.orderedListOfMigratables = orderedListOfMigratables
  }
}
