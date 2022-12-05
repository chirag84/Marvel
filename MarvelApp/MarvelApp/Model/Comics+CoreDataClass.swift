//
//  Comics+CoreDataClass.swift
//  MarvelApp
//
//  Created by Chirag on 05/12/22.
//
//

import Foundation
import CoreData

@objc(Comics)
public class Comics: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case collectionURI = "collectionURI"
        case available = "available"
        case items = "items"
    }

    required convenience public init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Comics", in: managedObjectContext) else {
                fatalError("Failed to decode Comics")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? container.decodeIfPresent(String.self, forKey: .collectionURI) {
            collectionURI = value
        }
        if let value = try? container.decodeIfPresent(Int64.self, forKey: .available) {
            available = Int64(value)
        }
        
//        if let value = try? container.decodeIfPresent([ComicItems].self, forKey: .items) {
//            hasItems = NSSet(array: value)
//        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(collectionURI, forKey: .collectionURI)
        try container.encode(available, forKey: .available)
    }
}

