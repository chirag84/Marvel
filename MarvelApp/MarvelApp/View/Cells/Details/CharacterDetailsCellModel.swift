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
    var isFavorite: Bool {get}
    
    func addToFavoriteTapped(_ isFavorite: Bool)
}

protocol CharacterDetailsCellModelDelegate: AnyObject {
    func addToFavoriteTapped(_ isFavorite: Bool)
}

class CharacterDetailsCellModel: CharacterDetailsCellModelProtocol {
    
    weak var delegate: CharacterDetailsCellModelDelegate?
    
    var titleText: String
    var imagePath: String
    var descriptionText: String
    var isFavorite: Bool
    
    init(character: MarvelCharacter, delegate: CharacterDetailsCellModelDelegate) {
        self.titleText = character.name
        self.imagePath = character.thumbnail ?? ""
        self.descriptionText = character.descriptions ?? ""
        self.isFavorite = CoreDataService.getFavouriteCharacter(Int(character.id))
        self.delegate = delegate
    }
    
    func addToFavoriteTapped(_ isFavorite: Bool) {
        delegate?.addToFavoriteTapped(isFavorite)
    }
}
