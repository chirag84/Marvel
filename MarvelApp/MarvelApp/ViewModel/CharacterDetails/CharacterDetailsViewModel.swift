//
//  CharacterDetailsViewModel.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import Foundation

class CharacterDetailsViewModel: CharacterDetailsViewModelProtocol {
    
    var selectedCharacter: MarvelCharacter
    var characterModels: [CharacterDetailsCellModel] = []
    var comicsModels: [ComicsCellModel] = []
    
    init(character: MarvelCharacter) {
        self.selectedCharacter = character
        characterModels.append(CharacterDetailsCellModel(character: selectedCharacter, delegate: self))
    }
   
    var numberOfComics: Int {
        return comicsModels.count
    }
    
    func collectionCellModel(indexPath: IndexPath) -> CharacterDetailsCellModelProtocol {
        return characterModels[0]
    }
    
    func comicCellModel(indexPath: IndexPath) -> ComicsCellModelProtocol {
        return comicsModels[indexPath.row]
    }
}

extension CharacterDetailsViewModel: CharacterDetailsCellModelDelegate {
    func addToFavoriteTapped(_ isFavorite: Bool) {
        CoreDataService.shared.addToFavorite(characterId: Int(selectedCharacter.id), isFavorite: isFavorite) { success in
            if(success) {
                NotificationCenter.default.post(name: NSNotification.Name("didChangeFavorite"), object: nil)
            }
        }
    }
}
