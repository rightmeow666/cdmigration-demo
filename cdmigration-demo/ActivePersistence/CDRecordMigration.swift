//
//  CDRecordMigration.swift
//  cdmigration-demo
//
//  Created by sudofluff on 10/8/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation

typealias BeforeMigrationBlock = () -> Void

typealias OnMigrationBlock = () -> Void

typealias AfterMigrationBlock = () -> Void

struct CDRecordMigration {
  var onMigrate: OnMigrationBlock
  
  var beforeMigrate: BeforeMigrationBlock?
  
  var afterMigrate: AfterMigrationBlock?
  
  func exec() throws {
    self.beforeMigrate?()
    self.onMigrate()
    self.afterMigrate?()
  }
  
  init(onMigrate: @escaping OnMigrationBlock, beforeMigrate: BeforeMigrationBlock? = nil, afterMigrate: AfterMigrationBlock? = nil) {
    self.onMigrate = onMigrate
    self.beforeMigrate = beforeMigrate
    self.afterMigrate = afterMigrate
  }
}
