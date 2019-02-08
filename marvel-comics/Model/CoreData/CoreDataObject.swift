//
//  CoreDataObject.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import CoreData

public protocol CoreDataObject: NSFetchRequestResult {
    var id: Int64 { get set }
}
