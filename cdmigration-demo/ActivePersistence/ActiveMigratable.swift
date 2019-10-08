//
//  ActiveMigratable.swift
//  cdmigration-demo
//
//  Created by sudofluff on 10/8/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation

typealias BeforeMigrationBlock = () -> Void

typealias OnMigrationBlock = () throws -> Void

typealias AfterMigrationBlock = () -> Void

protocol ActiveMigratable {
  var onMigrate: OnMigrationBlock { get }
  
  var beforeMigrate: BeforeMigrationBlock? { get }
  
  var afterMigrate: AfterMigrationBlock? { get }
  
  var hasValidObjectName: Bool { get }
  
  func perform() throws
}

extension ActiveMigratable {
  var beforeMigrate: BeforeMigrationBlock? { return nil }
  
  var afterMigrate: AfterMigrationBlock? { return nil }
  
  func perform() throws {
    if !self.hasValidObjectName {
      fatalError("Migration file does not conform to the valid naming convention.")
    }
    self.beforeMigrate?()
    try self.onMigrate()
    self.afterMigrate?()
  }
}
