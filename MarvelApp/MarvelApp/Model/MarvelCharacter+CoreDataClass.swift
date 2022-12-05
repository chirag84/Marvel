//
//  MarvelCharacter+CoreDataClass.swift
//  MarvelApp
//
//  Created by Chirag on 04/12/22.
//
//

import Foundation
import CoreData

@objc(MarvelCharacter)
public class MarvelCharacter: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case thumbnail = "thumbnail"
        //case comics = "comics"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextKey = CodingUserInfoKey.context,
              let managedObjectContext = decoder.userInfo[contextKey] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: Constants.Entity.character, in: managedObjectContext) else {
            
            fatalError("Failed to decode Characters")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int64.self, forKey: .id)
        
        if let value = try? container.decodeIfPresent(String.self, forKey: .name) {
            name = value
        }
        
        if let value = try? container.decodeIfPresent(Thumbnail.self, forKey: .thumbnail) {
            thumbnail = "\(value.path).\(value.extension)"
        }
        
        if let value = try? container.decodeIfPresent(String.self, forKey: .description) {
            descriptions = value
        }
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(descriptions, forKey: .description)
        try container.encode(thumbnail, forKey: .thumbnail)
    }
}
