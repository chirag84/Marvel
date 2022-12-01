//
//  CharactersCellModel.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation

protocol CharactersCellModelProtocol {
    var titleText: String {get}
    var imagePath: String {get}
}

class CharactersCellModel: CharactersCellModelProtocol {
    
    var titleText: String
    var imagePath: String
    
    init(character: MarvelCharacter) {
        self.titleText = character.name
        self.imagePath = character.thumbnail.urlPath()
    }
}
