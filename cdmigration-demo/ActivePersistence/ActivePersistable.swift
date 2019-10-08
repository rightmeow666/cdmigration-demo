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

typealias CompletionBlock = (Result<Void, Error>) -> Void

protocol ActivePersistable where Self: CDBaseRecord {
  var beforeSave: BeforeSaveBlock? { get }
  
  var afterSave: AfterSaveBlock? { get }
  
  var isValid: Bool { get }
  
  static func find(_ moc: NSManagedObjectContext, id: String) -> Self?
  
  static func findAll(_ moc: NSManagedObjectContext, byPredicate predicate: NSPredicate?, sortedBy sortDescriptors: [NSSortDescriptor]?) -> [Self]
  
  static func deleteAll(_ moc: NSManagedObjectContext, objects: [Self], completion: @escaping CompletionBlock)
  
  static func purge(_ moc: NSManagedObjectContext, completion: @escaping CompletionBlock)
  
  func save(_ moc: NSManagedObjectContext, block: @escaping OnSaveBlock, completion: @escaping CompletionBlock)
  
  func delete(_ moc: NSManagedObjectContext, completion: @escaping CompletionBlock)
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
  
  static func find(_ moc: NSManagedObjectContext, id: String) -> Self? {
    let predicate = NSPredicate(format: "id == %@", id)
    guard let entityName = Self.entity().name else { return nil }
    let fr = NSFetchRequest<Self>(entityName: entityName)
    fr.predicate = predicate
    do {
      return try moc.fetch(fr).first
    } catch let err {
      print(err)
      return nil
    }
  }
  
  static func findAll(_ moc: NSManagedObjectContext, byPredicate predicate: NSPredicate? = nil, sortedBy sortDescriptors: [NSSortDescriptor]? = nil) -> [Self] {
    guard let entityName = Self.entity().name else { return [] }
    let fr = NSFetchRequest<Self>(entityName: entityName)
    fr.predicate = predicate
    fr.sortDescriptors = sortDescriptors
    do {
      return try moc.fetch(fr)
    } catch let err {
      print(err)
      return []
    }
  }
  
  static func deleteAll(_ moc: NSManagedObjectContext, objects: [Self], completion: @escaping CompletionBlock) {
    moc.perform {
      objects.forEach( { moc.delete($0) })
      do {
        if moc.hasChanges {
          try moc.save()
          completion(.success(()))
        } else {
          // TODO: throw a designated internal error type
          throw "nothing has change, no need to save dude"
        }
      } catch let err {
        completion(.failure(err))
      }
    }
  }
  
  static func purge(_ moc: NSManagedObjectContext, completion: @escaping CompletionBlock) {
    let allObjects = self.findAll(moc)
    if allObjects.count == 0 {
      completion(.success(()))
    } else {
      self.deleteAll(moc, objects: allObjects) { (result) in
        switch result {
        case .failure(let err):
          completion(.failure(err))
        case .success(()):
          completion(.success(()))
        }
      }
    }
  }
  
  func save(_ moc: NSManagedObjectContext, block: @escaping OnSaveBlock, completion: @escaping CompletionBlock) {
    moc.perform {
      do {
        block()
        if moc.hasChanges {
          try self.beforeSave?()
          try moc.save()
          self.afterSave?()
          completion(.success(()))
        } else {
          // TODO: throw a designated internal error type
          throw "nothing has change, no need to save dude"
        }
      } catch let err {
        completion(.failure(err))
      }
    }
  }
  
  /// When deleting a record, always perform the operation on a dedicated moc in case the same moc is used for other operation for save.
  func delete(_ moc: NSManagedObjectContext, completion: @escaping CompletionBlock) {
    moc.perform {
      moc.delete(self)
      do {
        if moc.hasChanges {
          try moc.save()
          completion(.success(()))
        } else {
          // TODO: throw a designated internal error type
          throw "nothing has change, no need to save dude"
        }
      } catch let err {
        completion(.failure(err))
      }
    }
  }
}

extension String: Error {}
