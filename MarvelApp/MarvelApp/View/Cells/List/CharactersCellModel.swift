//
//  CharactersCellModel.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation

protocol CharactersCellModelProtocol {
    var character: MarvelCharacter {get set}
    var characterId: Int {get}
    var titleText: String {get}
    var imagePath: String {get}
    var isFavorite: Bool {get}
}

class CharactersCellModel: CharactersCellModelProtocol {
    var character: MarvelCharacter
    var characterId: Int
    var titleText: String
    var imagePath: String
    var isFavorite: Bool
    
    init(character: MarvelCharacter) {
        self.character = character
        
        self.characterId = Int(self.character.id)
        self.titleText = self.character.name
        self.imagePath = self.character.thumbnail ?? ""
        self.isFavorite =  CoreDataService.getFavouriteCharacter(Int(characterId))
    }
}
