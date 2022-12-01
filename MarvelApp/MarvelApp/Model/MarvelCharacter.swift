//
//  MarvelCharacter.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation

struct MarvelCharacter: Codable {
    var id: Int
    var name: String
    var thumbnail: Thumbnail
    var description: String
    var comics: Comics
}

struct Thumbnail: Codable {
    var path: String
    var `extension`: String
    
    func urlPath()-> String {
        return "\(path).\(`extension`)"
    }
}
