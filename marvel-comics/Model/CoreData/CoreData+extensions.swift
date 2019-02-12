//
//  CoreData+extensions.swift
//  EnglishLearning
//
//  Created by Pablo Guardiola on 27/01/2018.
//  Copyright © 2018 Pablo Guardiola. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    public func insert() {
        CoreData.context.insert(self)
    }
    
    public func delete() {
        CoreData.context.delete(self)
    }
}

extension CoreDataObject where Self: NSManagedObject {
    
    public static func get<T: CoreDataObject>(by id: Int64) -> T? {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        return (try? CoreData.context.fetch(fetchRequest))?.first
    }
    
    public static func exists(id: Int64) -> Bool {
        let fetchRequest = self.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        
        return ((try? CoreData.context.count(for: fetchRequest)) ?? 0) > 0
    }
    
    public static func getAll<T: CoreDataObject>() -> [T] {
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: String(describing: self))
        
        return (try? CoreData.context.fetch(fetchRequest)) ?? []
    }
}
