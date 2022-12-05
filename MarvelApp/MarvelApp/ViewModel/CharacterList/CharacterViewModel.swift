//
//  CharacterViewModel.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation
import CoreData

class CharacterViewModel: CharacterViewModelProtocol {
    var service: NetworkServiceProtocol?
    var characterModels: [CharactersCellModel] = []
    var hasReachedMaxOfCharacters: Bool = false
    var isNetworkSearchActive: Bool = false
    
    init(service: NetworkService) {
        self.service = service
    }
    
    var numberOfCharacters: Int {
        return characterModels.count
    }
    
    func fetchCharacters(offset: Int, name: String? = nil, completionHandler: @escaping () -> Void)  {
        
        if NetworkService.isConnectedToInternet() {
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
                                    
                    // Search in local once load data from api
                    if(self.isNetworkSearchActive) {
                        self.searchLocalCharacters(text: name ?? "") {
                            completionHandler()
                        }
                    }else {
                        let characters = self.getCharactersData(offset: offset)
                        characters.forEach { marvel in
                            self.characterModels.append(CharactersCellModel(character: marvel))
                        }
                        completionHandler()
                    }
                }
            }
        } else {
            //show local result
            if offset == 0 {
                self.characterModels = []
            }
            
            let characters = self.getCharactersData(offset: offset)
            characters.forEach { marvel in
                self.characterModels.append(CharactersCellModel(character: marvel))
            }
            completionHandler()
        }
    }
    
    // Search character form local database
    func searchLocalCharacters(text: String, completionHandler: @escaping () -> Void) {
        service?.searchLocalCharacter(text: text, completion: { result in
            
            DispatchQueue.main.async {
                self.characterModels = []
                switch result {
                case .success((let characters, _ )):
                    characters.forEach { marvel in
                        self.characterModels.append(CharactersCellModel(character: marvel))
                    }
                    completionHandler()
                    break
                case .failure(let error):
                    print(error)
                    completionHandler()
                    break
                }
            }
        })
    }
    
    // Get Marvel characters by offset/page
    func getCharactersData(offset: Int) -> [MarvelCharacter] {
        let context = CoreDataService.shared.persistentContainer.viewContext
        
        let characterData = context.fetchData(entity: MarvelCharacter.self, offset: offset)
        if let characters = characterData as? [MarvelCharacter] {
            return characters
        }
        return []
    }

    func searchCharactersByName(name: String, completionHandler: @escaping () -> Void) {
        self.hasReachedMaxOfCharacters = false
        
        if NetworkService.isConnectedToInternet() {
            self.isNetworkSearchActive = true
            self.fetchCharacters(offset: 0, name: name, completionHandler: completionHandler)
        }else{
            self.isNetworkSearchActive = false
            self.searchLocalCharacters(text: name, completionHandler: completionHandler)
        }
    }
    
    func collectionCellModel(indexPath: IndexPath) -> CharactersCellModelProtocol {
        return characterModels[indexPath.row]
    }
    
    func searchCancelled() {
        self.isNetworkSearchActive = false
        self.hasReachedMaxOfCharacters = false
    }
}
