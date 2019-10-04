//
//  ActivePersistable.swift
//  cdmigration-demo
//
//  Created by Jin He on 10/4/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation
import CoreData

typealias BeforeSaveBlock = () throws -> Void

typealias OnSaveBlock = () -> Void

typealias AfterSaveBlock = () -> Void

protocol ActivePersistable where Self: CDBaseRecord {
    var beforeSave: BeforeSaveBlock? { get }
    
    var afterSave: AfterSaveBlock? { get }
    
    var isValid: Bool { get }
    
    static func find(_ id: String) -> Self?
    
    static func findAll() -> [Self]
    
    static func purge() throws
    
    func save(_ block: OnSaveBlock) throws
    
    func delete() throws
}

extension ActivePersistable {
    var beforeSave: BeforeSaveBlock? { return nil }
    
    var afterSave: AfterSaveBlock? { return nil }
    
    var isValid: Bool {
        do {
            try self.beforeSave?()
            return true
        } catch {
            return false
        }
    }
    
    static func find(_ id: String) -> Self? {
        return nil
    }
    
    static func findAll() -> [Self] {
        return []
    }
    
    static func purge() throws {}
    
    func save(_ block: OnSaveBlock) throws {
        block()
        try self.beforeSave?()
        self.afterSave?()
    }
    
    func delete() throws {}
}
