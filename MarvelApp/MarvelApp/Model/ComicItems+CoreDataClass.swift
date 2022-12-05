//
//  ComicItems+CoreDataClass.swift
//  MarvelApp
//
//  Created by Chirag on 05/12/22.
//
//

import Foundation
import CoreData

@objc(ComicItems)
public class ComicItems: NSManagedObject {

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case resourceURI = "resourceURI"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "ComicItems", in: managedObjectContext) else {
                fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(String.self, forKey: .name) {
            name = value
        }
        if let value = try container.decodeIfPresent(String.self, forKey: .resourceURI) {
            resourceURI = value
        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(resourceURI, forKey: .resourceURI)
    }
}
