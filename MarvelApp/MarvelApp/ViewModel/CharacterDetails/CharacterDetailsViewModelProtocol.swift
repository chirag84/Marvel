//
//  CharacterDetailsViewModelProtocol.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import Foundation

protocol CharacterDetailsViewModelProtocol {
    
    var selectedCharacter: MarvelCharacter { get set }
    var numberOfComics: Int {get}
    
    func collectionCellModel(indexPath: IndexPath) -> CharacterDetailsCellModelProtocol
    func comicCellModel(indexPath: IndexPath) -> ComicsCellModelProtocol
}
