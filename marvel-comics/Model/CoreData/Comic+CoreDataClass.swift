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
        case images
        case descriptionText = "description"
    }
    
    public var thumbnail: ComicImage? = nil
    public var images: [ComicImage] = []
    
    public var thumbnailUrl: URL? {
        guard let thumbnail = self.thumbnail else { return nil }
        
        return URL(string: "\(thumbnail.path).\(thumbnail.extension)")
    }
    
    convenience init(from other: Comic) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Comic", in: CoreData.context)!, insertInto: nil)
        
        self.id = other.id
        self.thumbnail = other.thumbnail
        self.images = other.images
        self.title = other.title
        self.descriptionText = other.descriptionText
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Comic", in: CoreData.context)!, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.thumbnail = try container.decode(ComicImage.self, forKey: .thumbnail)
        self.images = try container.decode([ComicImage].self, forKey: .images)
        self.descriptionText = try container.decodeIfPresent(String.self, forKey: .descriptionText)
    }
}
