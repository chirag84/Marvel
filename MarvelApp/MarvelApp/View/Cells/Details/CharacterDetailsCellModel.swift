//
//  CharacterDetailsCellModel.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import Foundation

protocol CharacterDetailsCellModelProtocol {
    var titleText: String {get}
    var imagePath: String {get}
    var descriptionText: String {get}
}

class CharacterDetailsCellModel: CharacterDetailsCellModelProtocol {
   
    var titleText: String
    var imagePath: String
    var descriptionText: String
    
    init(character: MarvelCharacter) {
        self.titleText = character.name
        self.imagePath = character.thumbnail.urlPath()
        self.descriptionText = character.description
    }
}
