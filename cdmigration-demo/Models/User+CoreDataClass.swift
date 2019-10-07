//
//  User+CoreDataClass.swift
//  cdmigration-demo
//
//  Created by Jin He on 10/4/19.
//  Copyright © 2019 Jin He. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
final public class User: CDBaseRecord {

}

extension User: ActivePersistable {
}
