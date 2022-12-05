//
//  MarvelCharacter+CoreDataProperties.swift
//  MarvelApp
//
//  Created by Chirag on 04/12/22.
//
//

import Foundation
import CoreData


extension MarvelCharacter {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MarvelCharacter> {
        return NSFetchRequest<MarvelCharacter>(entityName: Constants.Entity.character)
    }
    
    @NSManaged public var descriptions: String?
    @NSManaged public var id: Int64
    @NSManaged public var isFavorite: Bool
    @NSManaged public var name: String
    @NSManaged public var thumbnail: String?
    
}

extension MarvelCharacter : Identifiable {
    
}
