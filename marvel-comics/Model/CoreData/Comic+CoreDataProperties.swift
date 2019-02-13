//
//  Comic+CoreDataProperties.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 14/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//
//

import Foundation
import CoreData


extension Comic {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comic> {
        return NSFetchRequest<Comic>(entityName: "Comic")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var id: Int64
    @NSManaged public var pageCount: Int16
    @NSManaged public var title: String?
    @NSManaged public var thumbnail: ComicImage?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension Comic {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ComicImage)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ComicImage)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
