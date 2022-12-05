//
//  Comics+CoreDataProperties.swift
//  MarvelApp
//
//  Created by Chirag on 05/12/22.
//
//

import Foundation
import CoreData


extension Comics {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comics> {
        return NSFetchRequest<Comics>(entityName: "Comics")
    }

    @NSManaged public var available: Int64
    @NSManaged public var collectionURI: String?
    @NSManaged public var belonToMarvelCharacter: MarvelCharacter?
    @NSManaged public var hasItems: NSSet?

}

// MARK: Generated accessors for hasItems
extension Comics {

    @objc(addHasItemsObject:)
    @NSManaged public func addToHasItems(_ value: ComicItems)

    @objc(removeHasItemsObject:)
    @NSManaged public func removeFromHasItems(_ value: ComicItems)

    @objc(addHasItems:)
    @NSManaged public func addToHasItems(_ values: NSSet)

    @objc(removeHasItems:)
    @NSManaged public func removeFromHasItems(_ values: NSSet)

}

extension Comics : Identifiable {

}
