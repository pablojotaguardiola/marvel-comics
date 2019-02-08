//
//  Comic+CoreDataProperties.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//
//

import Foundation
import CoreData


extension Comic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comic> {
        return NSFetchRequest<Comic>(entityName: "Comic")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?

}
