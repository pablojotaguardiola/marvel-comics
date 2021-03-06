//
//  Comic+CoreDataClass.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//
//

import Foundation
import CoreData


public class Comic: NSManagedObject, Decodable, CoreDataObject {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case thumbnail
        case descriptionText = "description"
        case pageCount
        case images
    }
    
    convenience init(from other: Comic) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Comic", in: CoreData.context)!, insertInto: nil)
        
        self.id = other.id
        if let otherThumbnail = other.thumbnail {
            self.thumbnail = ComicImage(from: otherThumbnail)
        }
        self.title = other.title
        self.descriptionText = other.descriptionText
        self.pageCount = other.pageCount
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Comic", in: CoreData.context)!, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.thumbnail = try container.decodeIfPresent(ComicImage.self, forKey: .thumbnail)
        self.descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText)
        self.pageCount = try container.decode(Int16.self, forKey: .pageCount)
        if let imagesArray = try container.decodeIfPresent([ComicImage].self, forKey: .images) {
            self.images = NSSet(array: imagesArray)
        }
    }
    
    @discardableResult
    public func insertIfNeeded() -> Bool {
        if Comic.exists(id: self.id) {
            return false
        }
        
        self.thumbnail?.insert()
        
        self.images?.forEach { ($0 as? ComicImage)?.insert() }
        
        self.insert()
        return true
    }
    
    public static func getAll(withTitleLike searchText: String) -> [Comic] {
        let fetchRequest: NSFetchRequest<Comic> = NSFetchRequest<Comic>(entityName: String(describing: self))
        fetchRequest.predicate = NSPredicate(format: "title contains[c] %@", searchText)
    
        return (try? CoreData.context.fetch(fetchRequest)) ?? []
    }
}
