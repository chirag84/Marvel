//
//  CharacterViewModel.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation

class CharacterViewModel: CharacterViewModelProtocol {
   
    var service: NetworkServiceProtocol?
    var characterModels: [CharactersCellModel] = []
    
    init(service: NetworkService) {
        self.service = service
    }
    
    var numberOfCharacters: Int {
        return characterModels.count
    }
    
    func fetchCharacters(offset: Int, name: String? = nil, completionHandler: @escaping () -> Void)  {
        if offset == 0 {
            self.characterModels = []
        }
        
        service?.characters(offset: 0, search: name) { [unowned self] result in
            switch result {
            case .failure(let error):
                print(error)
                completionHandler()
                
            case .success(let response):
                response.0.map({ marvel in
                    self.characterModels.append(CharactersCellModel(character: marvel))
                })
                completionHandler()
            }
        }
    }

    func searchCharactersByName(name: String, completionHandler: @escaping () -> Void) {
        self.characterModels = []
        self.fetchCharacters(offset: 0, name: name, completionHandler: completionHandler)
    }
    
    func collectionCellModel(indexPath: IndexPath) -> CharactersCellModelProtocol {
        return characterModels[indexPath.row]
    }
}
