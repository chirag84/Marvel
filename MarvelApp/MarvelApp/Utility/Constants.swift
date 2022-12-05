//
//  Constants.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation

struct Constants {
    
    struct API {
        static let baseUrl = "https://gateway.marvel.com/v1/public/"
        static let characters = "\(Constants.API.baseUrl)/characters"
        static let privateKey = "cd3365f42c69f1435caa8383b2b9e82ecccfca78"
        static let publicKey = "f7dd6da14fb22dc378cabc827864c51a"
         
        static var hash:String {
            let timestamp = "\(Date().timeIntervalSinceNow)"
            let string = "\(timestamp)\(Constants.API.privateKey)\(Constants.API.publicKey)".md5()
            return string
        }
        
        // No. of record fetch limit
        static let limit = 20
    }
        
    struct Key {
        static let limit = "limit"
        static let offset = "offset"
        static let timestamp = "ts"
        static let hash = "hash"
        static let publicKey = "apikey"
        static let nameStartsWith = "nameStartsWith"
    }

    struct Label {
        static let marvelCharacters = "Marvel Characters"
        static let characterDetails = "Character Details"
        static let searchByCharacter = "Search by character"
    }
    
    struct Cell {
        static let charactersCell = "CharactersCell"
        static let characterDeatilsCell = "CharacterDeatilsCell"
        static let comicsCell = "ComicsCell"
    }
    
    struct Entity {
        static let character = "MarvelCharacter"
        static let favorite = "Favorite"
    }
}

