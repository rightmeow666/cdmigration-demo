//
//  AddDatetimeToUser.swift
//  cdmigration-demo
//
//  Created by sudofluff on 10/8/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation

final class AddDatetimeToUser: BaseMigration, ActiveMigratable {
  var beforeMigrate: BeforeMigrationBlock? {
    return nil
  }
  
  var afterMigrate: AfterMigrationBlock? {
    return nil
  }
  
  var onMigrate: OnMigrationBlock {
    return {
      print("lightweight migration, nothing to do there")
    }
  }
}
