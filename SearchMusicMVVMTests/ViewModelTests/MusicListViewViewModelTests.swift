//
//  ViewModelTests.swift
//  SearchMusicMVVMTests
//
//  Created by Michael Iskandar on 29/08/21.
//  Copyright © 2021 Michael Iskandar. All rights reserved.
//
import XCTest
import Foundation
@testable import SearchMusicMVVM

class MusicListViewViewModelTests: XCTestCase {
    
    var sut: MusicListViewViewModel!
    var mockAPITests = MockAPITests()
    
//    func makeSUT(expectation: XCTestExpectation) -> MusicListViewViewModel {
//        let mockAPITest = MockAPITests()
//        mockAPITest.expectation = expectation
//        let sut = MusicListViewViewModel(service: mockAPITest)
//        return sut
//    }
    
    override func setUp() {
        super.setUp()
        sut = MusicListViewViewModel(service: mockAPITests)
    }
    
    func testInitialFetchMusics() {
        let initial = expectation(description: "Musics already fetched")
//        let sut = makeSUT(expectation: initial)
        mockAPITests.expectation = initial
        sut.fetchMusics()
        wait(for: [initial], timeout: 30.0)
        XCTAssertGreaterThan(sut.numberOfItemsInSection, 0)
    }

    func testFetchMoreData() {
        self.testInitialFetchMusics()
        let more = expectation(description: "Load More Data")
//        let sut = makeSUT(expectation: more)
        mockAPITests.expectation = more
        sut.fetchMoreData()
        wait(for: [more], timeout: 20.0)
        XCTAssertGreaterThan(sut.numberOfItemsInSection, 50)
    }

    func testSearchMusics() {
        let search = expectation(description: "Music already searched")
//        let sut = makeSUT(expectation: search)
        mockAPITests.expectation = search
        sut.searchMusics(query: "Taylor")
        wait(for: [search], timeout: 20.0)
        XCTAssertGreaterThan(sut.numberOfItemsInSection, 0)
    }

}

class MockAPITests: XCTestCase, MusicService{

    var expectation: XCTestExpectation?
    private let baseURL = "https://itunes.apple.com/search"
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    private let session: URLSession = .shared
    
    func fetchMusics(completion: @escaping (Result<MusicResponse, APIError>) -> Void) {
        fetchResources(params: ["media": "music",
                                "term": "home"],
                       completion: completion)
    }
    
    func searchMusic(query: String, limit: Int = 25, offset: Int = 0, completion: @escaping (Result<MusicResponse, APIError>) -> Void) {
        fetchResources(params: ["media": "music",
                                "term": query,
                                "limit": String(limit),
                                "offset": String(offset)],
                       completion: completion)
    }
    
    private func fetchResources<T: Decodable>(params: [String: String]?, completion: @escaping (Result<T, APIError>) -> Void) {
        guard var component = URLComponents(string: baseURL) else {
            completion(.failure(.invalidEndpoint))
            XCTFail("Invalid URL Point")
            return
        }
        
        if let params = params {
            component.setQueryItems(with: params)
        }
                
        guard let url = component.url else {
            completion(.failure(.invalidEndpoint))
            XCTFail("Invalid End Point")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                XCTFail("No Data Downloaded")
                return
            }
            
            do {
                let results = try self.decoder.decode(T.self, from: data)
                completion(.success(results))
                self.expectation?.fulfill()
            } catch {
                completion(.failure(.invalidData))
                self.expectation?.fulfill()
            }
        }.resume()
    }
    
    
}
