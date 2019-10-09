//
//  ActiveMigrationManager.swift
//  cdmigration-demo
//
//  Created by sudofluff on 10/8/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation

struct ActiveMigrationManager{
  enum MigrationKey: String {
    case migrated = "Migrated"
  }
  
  /// This is an ordered list of migration files. If you don't remember what order they should be, please refer to Git or the created date on the swift file meta data on its header area.
  private let orderedListOfMigratables: [ActiveMigratable]
  
  private var pendingMigrations: [ActiveMigratable] {
    if let migrated = UserDefaults.standard.array(forKey: MigrationKey.migrated.rawValue) as? Array<String>, !migrated.isEmpty {
      return self.orderedListOfMigratables.filter({ !migrated.contains($0.uuid) })
    } else {
      return self.orderedListOfMigratables
    }
  }
  
  private func archiveMigration(_ m: ActiveMigratable) {
    if var migrated = UserDefaults.standard.array(forKey: MigrationKey.migrated.rawValue) as? Array<String> {
      migrated.append(m.uuid)
      UserDefaults.standard.set(migrated, forKey: MigrationKey.migrated.rawValue)
    } else {
      var arr = Array<String>()
      arr.append(m.uuid)
      UserDefaults.standard.set(arr, forKey: MigrationKey.migrated.rawValue)
    }
  }
  
  private func emptyMigrationArchive() {
    UserDefaults.standard.removeObject(forKey: MigrationKey.migrated.rawValue)
  }
  
  func exec(completion: (Result<Void, Error>) -> Void) {
    if !self.pendingMigrations.isEmpty {
      do {
        try self.pendingMigrations.forEach { (m) in
          try m.perform()
          self.archiveMigration(m)
          print("migrated \(m.uuid)")
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
