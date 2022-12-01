//
//  Comics.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import Foundation

struct Comics: Codable {
    var available: Int
    var collectionURI: String
    var items: [Resource]
    var returned: Int
}

struct Resource: Codable {
    var resourceURI: String
    var name: String
}
