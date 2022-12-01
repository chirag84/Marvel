//
//  NetworkService.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation
import Alamofire

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
        
        if let name = search, !name.isEmpty {
            params[Constants.Key.nameStartsWith] = name
        }
      
        print("PATH:\(path)- \(offset)")
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
                    let result = try JSONDecoder().decode(NetworkResponse<T>.self, from: data)
                    completion(.success((result.results, result.total)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


// NetworkResponse to deal with general response from Marvel API
struct NetworkResponse<T: Decodable>: Decodable {
    let results: T
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case results
        case total
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .data)
        results = try additionalInfo.decode(T.self, forKey: .results)
        total = try additionalInfo.decode(Int.self, forKey: .total)
    }
}
