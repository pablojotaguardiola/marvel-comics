//
//  CoreData+extensions.swift
//  EnglishLearning
//
//  Created by Pablo Guardiola on 27/01/2018.
//  Copyright © 2018 Pablo Guardiola. All rights reserved.
//

import Foundation
import CoreData

extension CoreDataObject where Self: NSManagedObject {

    fileprivate func insert() {
        CoreData.context.insert(self)
    }
    
    public func delete() {
        CoreData.context.delete(self)
    }
    
    public func getCount(predicate: NSPredicate? = nil) -> Int {
        let fetchRequest = type(of: self).fetchRequest()
        
        fetchRequest.predicate = predicate
        
        return (try? CoreData.context.count(for: fetchRequest)) ?? 0
    }
    
    public static func get<T: CoreDataObject>(by id: Int64, context: NSManagedObjectContext? = nil) -> T? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        return (try? CoreData.context.fetch(fetchRequest))?.first
    }
    
    public static func exists(id: Int64) -> Bool {
        let fetchRequest = self.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        return ((try? CoreData.context.count(for: fetchRequest)) ?? 0) > 0
    }
    
    @discardableResult
    public func insertIfNeeded() -> Bool {
        if Self.exists(id: self.id) {
            return false
        }
        self.insert()
        return true
    }
    
    /*public static func getCountSync(context: NSManagedObjectContext? = nil) -> Int {
        return (try? (context ?? CoreData.context).count(for: self.fetchRequest())) ?? 0
    }
    
    public static func getFirst<T: CoreDataObject>(context: NSManagedObjectContext? = nil) -> T? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        
        fetchRequest.predicate = NSPredicate(format: "wasDeleted = 0")
        
        return (try? (context ?? CoreData.context).fetch(fetchRequest))?.first
    }
    
    public static func getAll<T: CoreDataObject>(context: NSManagedObjectContext? = nil) -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        
        fetchRequest.predicate = NSPredicate(format: "wasDeleted = 0")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastEdited", ascending: false)]
    
        return (try? (context ?? CoreData.context).fetch(fetchRequest)) ?? []
    }
    
    public static func get<T: CoreDataObject>(by id: Int64, context: NSManagedObjectContext? = nil) -> T? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        return (try? (context ?? CoreData.context).fetch(fetchRequest))?.first
    }
    
    public static func getActive<T: CoreDataObject>(by id: Int64, context: NSManagedObjectContext? = nil) -> T? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        
        fetchRequest.predicate = NSPredicate(format: "id = %@ AND wasDeleted = 0", "\(id)")
        
        return (try? (context ?? CoreData.context).fetch(fetchRequest))?.first
    }
    
    public static func get<T: CoreDataObject>(in idArray: [Int64], context: NSManagedObjectContext? = nil) -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        
        fetchRequest.predicate = NSPredicate(format: "id IN %@ AND wasDeleted = 0", idArray)
        
        return (try? (context ?? CoreData.context).fetch(fetchRequest)) ?? []
    }

    static func getToUpload<T: CoreDataObject>(context: NSManagedObjectContext? = nil) -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))

        fetchRequest.predicate = NSPredicate(format: "isPushedOnline = 0")

        return (try? (context ?? CoreData.context).fetch(fetchRequest)) ?? []
    }
    
    static func get<T: CoreDataObject>(editedAfter timestampInfo: TimestampInfo, fetchLimit: Int? = nil, context: NSManagedObjectContext) -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastEdited", ascending: true), NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "(lastEdited = \(timestampInfo.timestamp) AND id > \(timestampInfo.lastId)) OR lastEdited > \(timestampInfo.timestamp)")
        
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        return (try? context.fetch(fetchRequest)) ?? []
    }*/
}
