//
//  Post+CoreDataProperties.swift
//  cdmigration-demo
//
//  Created by Jin He on 10/4/19.
//  Copyright © 2019 Jin He. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var title: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var user: User?

}
