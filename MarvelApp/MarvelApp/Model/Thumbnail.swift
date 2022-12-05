//
//  MarvelCharacter.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation

struct Thumbnail: Codable {
    var path: String
    var `extension`: String
    
    func urlPath()-> String {
        return "\(path).\(`extension`)"
    }
}
