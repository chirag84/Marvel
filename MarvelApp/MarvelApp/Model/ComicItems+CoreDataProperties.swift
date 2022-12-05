//
//  ComicItems+CoreDataProperties.swift
//  MarvelApp
//
//  Created by Chirag on 05/12/22.
//
//

import Foundation
import CoreData


extension ComicItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ComicItems> {
        return NSFetchRequest<ComicItems>(entityName: "ComicItems")
    }

    @NSManaged public var name: String?
    @NSManaged public var resourceURI: String?
    @NSManaged public var belongToComic: Comics?

}

extension ComicItems : Identifiable {

}
