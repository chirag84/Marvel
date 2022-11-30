//
//  NetworkServiceProtocol.swift
//  MarvelApp
//
//  Created by Chirag on 30/11/22.
//

import Foundation

protocol NetworkServiceProtocol {
     func characters(offset: Int?, search: String?, completion: @escaping(Result<([MarvelCharacter], totalAmount: Int)>) -> Void)
}

enum Result<T> {
    case success(T)
    case failure(Error)
}

enum ErrorMessage: Error {
    case invalidData
}
