//
//  CharacterViewModel.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation

class CharacterViewModel: CharacterViewModelProtocol {
    var dataService: CoreDataServiceProtocol?
    var service: NetworkServiceProtocol?
    var characterModels: [CharactersCellModel] = []
    var hasReachedMaxOfCharacters: Bool = false
    
    
    init(service: NetworkService, dataService: CoreDataService) {
        self.service = service
        self.dataService = dataService
    }
    
    var numberOfCharacters: Int {
        return characterModels.count
    }
    
    func fetchCharacters(offset: Int, name: String? = nil, completionHandler: @escaping () -> Void)  {
        
        // Reset records for zero offset
        if offset == 0 {
            self.characterModels = []
        }
        
        // Return if fetched max records of characters
        guard !hasReachedMaxOfCharacters else {
            completionHandler()
            return
        }
        
        service?.characters(offset: offset, search: name) { [unowned self] result in
            switch result {
            case .failure(let error):
                print(error)
                completionHandler()
                
            case .success(let response):
                self.hasReachedMaxOfCharacters = response.totalAmount <= offset + Constants.API.limit
         
                // Save characters to local database
                dataService?.saveCharactersData(characters: response.0, completion: { status in
                    if(status){
                        print("saved successfully!!")
                    }
                })
                
                response.0.map({ marvel in
                    self.characterModels.append(CharactersCellModel(character: marvel))
                })
                completionHandler()
            }
        }
    }

    func searchCharactersByName(name: String, completionHandler: @escaping () -> Void) {
        self.hasReachedMaxOfCharacters = false
        self.fetchCharacters(offset: 0, name: name, completionHandler: completionHandler)
    }
    
    func collectionCellModel(indexPath: IndexPath) -> CharactersCellModelProtocol {
        return characterModels[indexPath.row]
    }
    
    func searchCancelled() {
        self.hasReachedMaxOfCharacters = false
    }
}
