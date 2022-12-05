//
//  Favorite+CoreDataProperties.swift
//  MarvelApp
//
//  Created by Chirag on 04/12/22.
//
//

import Foundation
import CoreData


extension Favorite {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: Constants.Entity.favorite)
    }
    
    @NSManaged public var id: Int64
    @NSManaged public var isFavorite: Bool
    
}

extension Favorite : Identifiable {
    
}
