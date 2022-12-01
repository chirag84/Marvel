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
        characterModels.append(CharacterDetailsCellModel(character: selectedCharacter))
        
        self.selectedCharacter.comics.items.forEach { items in
            
            //On the Character detail page list the first five Comics of that character.
            if(comicsModels.count == 5) {
                return
            }
            comicsModels.append(ComicsCellModel(resource: items))
        }
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
