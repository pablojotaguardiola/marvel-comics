//
//  ComicImage+CoreDataProperties.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 10/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//
//

import Foundation
import CoreData


extension ComicImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComicImage> {
        return NSFetchRequest<ComicImage>(entityName: "ComicImage")
    }

    @NSManaged public var path: String?
    @NSManaged public var extensionString: String?
    @NSManaged public var comic: Comic?

}
