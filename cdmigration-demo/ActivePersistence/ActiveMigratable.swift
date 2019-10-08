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
  
  func perform() throws
}

extension ActiveMigratable {
  var beforeMigrate: BeforeMigrationBlock? { return nil }
  
  var afterMigrate: AfterMigrationBlock? { return nil }
  
  func perform() throws {
    self.beforeMigrate?()
    try self.onMigrate()
    self.afterMigrate?()
  }
}
