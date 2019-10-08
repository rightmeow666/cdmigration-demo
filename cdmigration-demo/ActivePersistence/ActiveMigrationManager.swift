//
//  ActiveMigrationManager.swift
//  cdmigration-demo
//
//  Created by sudofluff on 10/8/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation

enum MigrationDirectory {
  case `default`
  case custom(_ path: String)
  
  var path: String {
    switch self {
    case .default:
      // TODO: defines a default path in the app directory
      return ""
    case .custom(let p):
      return p
    }
  }
}

struct ActiveMigrationManager {
  private let pathForMigrationDir: String
  
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
  
  init(pathForMigrationDir: MigrationDirectory = .default) {
    self.pathForMigrationDir = pathForMigrationDir.path
  }
}
