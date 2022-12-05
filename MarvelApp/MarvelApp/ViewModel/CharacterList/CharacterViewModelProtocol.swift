//
//  CharacterViewModelProtocol.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation
import UIKit

protocol CharacterViewModelProtocol {
   
    var characterModels: [CharactersCellModel] {get}
    var numberOfCharacters: Int {get}
   
    func fetchCharacters(offset: Int, name: String?, completionHandler: @escaping () -> Void)
    func collectionCellModel(indexPath: IndexPath) -> CharactersCellModelProtocol
}
