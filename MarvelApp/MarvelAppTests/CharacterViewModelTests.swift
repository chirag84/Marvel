//
//  CharacterViewModelTests.swift
//  MarvelAppTests
//
//  Created by Chirag on 01/12/22.
//

import XCTest

@testable import MarvelApp

class CharacterViewModelTests: XCTestCase {
    private var viewModel: CharacterViewModel!
    private var networkService: NetworkService!
    private var dataService: CoreDataService!

    override func setUp() {
        super.setUp()
        networkService = NetworkService()
        dataService = CoreDataService()
        viewModel = CharacterViewModel(service: networkService, dataService: dataService)
    }
    
    override func tearDown() {
        networkService = nil
        viewModel = nil
    }
    
    func testFetchCharacter() {
        let promise = expectation(description: "FetchCharacter")
        viewModel.fetchCharacters(offset: 0) {
            self.networkService.characters(offset: 0, search: "") { result in
               
                switch result {
                case .success((let response, let totalAmount)):
                    XCTAssertEqual(totalAmount, 1562)
                    XCTAssertEqual(response.count, 20)
                    XCTAssertEqual(response.first?.name, "3-D Man")
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSearchCharacter() {
        let promise = expectation(description: "SearchCharacter")
        viewModel.fetchCharacters(offset: 0) {
            self.networkService.characters(offset: 0, search: "Abo") { result in
               
                switch result {
                case .success((let response, let totalAmount)):
                    XCTAssertEqual(totalAmount, 2)
                    XCTAssertNotEqual(response.count, 1)
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCharacterComics() {
        let promise = expectation(description: "CharacterComics")
        viewModel.fetchCharacters(offset: 0) {
            self.networkService.characters(offset: 0, search: "") { result in
               
                switch result {
                case .success((let response, _)):
                    XCTAssertNotEqual(response.first?.comics.items.count, 4)
                    promise.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error)")
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
