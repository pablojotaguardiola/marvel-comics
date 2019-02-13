//
//  ComicImage+CoreDataClass.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 09/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//
//

import Foundation
import CoreData


public class ComicImage: NSManagedObject, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case path
        case extensionString = "extension"
    }
    
    public var url: URL? {
        guard
            let imagePath = self.path,
            let imageExtension = self.extensionString
            else { return nil }
        
        return URL(string: "\(imagePath).\(imageExtension)")
    }
    
    convenience init(from other: ComicImage) {
        self.init(entity: NSEntityDescription.entity(forEntityName: "ComicImage", in: CoreData.context)!, insertInto: nil)
        
        self.path = other.path
        self.extensionString = other.extensionString
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: NSEntityDescription.entity(forEntityName: "ComicImage", in: CoreData.context)!, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.path = try container.decode(String?.self, forKey: .path)
        self.extensionString = try container.decode(String?.self, forKey: .extensionString)
    }
}
