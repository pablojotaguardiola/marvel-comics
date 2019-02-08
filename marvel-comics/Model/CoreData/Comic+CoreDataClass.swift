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


public class Comic: NSManagedObject, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
    }
    
    // MARK: - Decodable
    required convenience public init(from decoder: Decoder) throws {
        self.init(entity: NSEntityDescription.entity(forEntityName: "Comic", in: CoreData.context)!, insertInto: nil)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int64.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
    }
}
