//
//  CoreData.swift
//  InstaCollege
//
//  Created by Pablo Guardiola on 19/11/2017.
//  Copyright © 2017 Pablo Guardiola. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct CoreData {
    
    /*
     This avoids to call UIKit from background queue
     */
    fileprivate static var _context: NSManagedObjectContext? = nil
    
    static var context: NSManagedObjectContext {
        get {
            if _context != nil {
                return _context!
            }
            else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                _context = appDelegate.persistentContainer.viewContext
                return _context!
            }
        }
    }
    
    static func save() {
        _ = try? context.save()
    }
}
