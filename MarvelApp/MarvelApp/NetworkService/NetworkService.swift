//
//  NetworkService.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation
import Alamofire
import CoreData

class NetworkService: NetworkServiceProtocol {
    
    // Authenticat request with public and private keys
    private lazy var defaultParams: [String: Any] = {
        let timestamp = String(Date().timeIntervalSince1970 * 1000)
        let hash = "\(timestamp)\(Constants.API.privateKey)\(Constants.API.publicKey)".md5()
        print(timestamp)
        return [
            Constants.Key.timestamp: timestamp,
            Constants.Key.hash: hash,
            Constants.Key.publicKey: Constants.API.publicKey
        ]
    }()
    
    /// Internet rechability checking
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func characters(offset: Int? = 0, search: String?, completion: @escaping(Result<([MarvelCharacter], totalAmount: Int)>) -> Void) {
        genericRequest(path: Constants.API.characters, offset: offset!, search: search, limit: Constants.API.limit, completion: completion)
    }
    
    /// - Parameters:
    ///   - path: the api url path
    ///   - offset: the start point from where to get the no. of data
    ///   - limit: the limit of data to retrive
    ///   - completion: returns an array of the model requested and a boolean that informs if has reached the maximum amount of data of that model
    private func genericRequest<T: Decodable>(path: String, offset: Int, search: String?, limit: Int, completion: @escaping(Result<(T, totalAmount: Int)>) -> Void) {
        
        var params = defaultParams
        params[Constants.Key.limit] = limit
        params[Constants.Key.offset] = offset
        
        // Search result if name is not empty
        if let name = search, !name.isEmpty {
            params[Constants.Key.nameStartsWith] = name
        }
      
        AF.request(path,
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding(destination: .queryString),
                   headers: nil)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                do {
                    guard let data = response.data else {
                        completion(.failure(ErrorMessage.invalidData))
                        return
                    }
                    self.saveCharacterDataToDatabase(data: data, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    func saveCharacterDataToDatabase<T: Decodable>(data: Data, completion: @escaping(Result<(T, totalAmount: Int)>) -> Void) {
        
        CoreDataService.shared.persistentContainer.performBackgroundTask { (managedObjectContext) in
            
            // To avoid changes conflict in memory
            managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            let decoder = JSONDecoder()
            if let context = CodingUserInfoKey.context {
                decoder.userInfo[context] = managedObjectContext
            }
            
            do {
                let response = try decoder.decode(NetworkResponse<T>.self, from: data)
                
                // Save to local database
                if managedObjectContext.hasChanges {
                    try managedObjectContext.save()
                }
                print(response.results.self)
                completion(.success((response.results, response.total)))
               
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    // Search marvel character by name
    func searchLocalCharacter(text: String,
                              completion:  @escaping(Result<([MarvelCharacter], totalAmount: Int)>) -> Void) {
        
        // Predicate search by name
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
        
        if let characters = CoreDataService.shared.persistentContainer.viewContext.fetchData(entity: MarvelCharacter.self, offset: 0, predicate: predicate) as? [MarvelCharacter] {
            completion(.success((characters, totalAmount: characters.count)))
        } else {
            completion(.failure(ErrorMessage.invalidData))
        }
    }
    
}
