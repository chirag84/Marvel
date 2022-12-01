//
//  ComicCellModel.swift
//  MarvelApp
//
//  Created by Chirag on 01/12/22.
//

import Foundation

protocol ComicsCellModelProtocol {
    var resource: Resource {get}
    var titleText: String {get}
    var imagePath: String {get}
}

class ComicsCellModel: ComicsCellModelProtocol {
    
    var resource: Resource
    var titleText: String
    var imagePath: String
    
    init(resource: Resource) {
        self.resource = resource
        
        self.titleText = self.resource.name
        self.imagePath = self.resource.resourceURI
       
    }
}
