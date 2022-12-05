//
//  Marvel.swift
//  MarvelApp
//
//  Created by Chirag on 30/12/22.
//

import Foundation

struct Marvel: Decodable {
    var code: Int?
    var status, copyright, attributionText, attributionHTML: String?
    var etag: String?
    var data: MarvelData?
}

// MARK: - Data model
struct MarvelData: Decodable {
    var offset, limit, total, count: Int?
    var results: [MarvelCharacter]?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    enum NestedCodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let additionalInfo = try values.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .data)
       
        results = try additionalInfo.decode([MarvelCharacter].self, forKey: .results)
        total = try additionalInfo.decode(Int.self, forKey: .total)
    }
}
