//
//  BaseMigration.swift
//  cdmigration-demo
//
//  Created by sudofluff on 10/8/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation

class BaseMigration {
  private let name: String
  
  let uuid: String
  
  init(uuid: String) {
    self.name = String(describing: BaseMigration.self)
    self.uuid = uuid
  }
}

extension BaseMigration: Equatable {
  static func == (lhs: BaseMigration, rhs: BaseMigration) -> Bool {
    return lhs.uuid == rhs.uuid
  }
}
