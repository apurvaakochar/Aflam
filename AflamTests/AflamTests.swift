//
//  AflamTests.swift
//  AflamTests
//
//  Created by Apurva Kochar on 8/30/18.
//  Copyright © 2018 careem. All rights reserved.
//

import XCTest
import RealmSwift

@testable import Aflam

class AflamTests: XCTestCase {
    
    var movieUnderTest: Movie!
    var searchResultsUnderTest: SearchResultsInteractor!
    var serverRequestUnderTest: ServerRequest!
    
    override func setUp() {
        super.setUp()
        serverRequestUnderTest = ServerRequest()
        searchResultsUnderTest = SearchResultsInteractor()
        
        let dictionary = ["poster_path": "", "release_date": "1970-12-12", "title": "Aladdin", "overview" : "It is a fanatstic movie!"]
        movieUnderTest = Movie(dictionary)
    }
    
    override func tearDown() {
        movieUnderTest = nil
        serverRequestUnderTest = nil
        searchResultsUnderTest = nil
        super.tearDown()
    }
    
    func testMovieAttributes() {
        XCTAssertEqual(movieUnderTest.overview, "It is a fanatstic movie!")
        XCTAssertEqual(movieUnderTest.date, "1970-12-12")
        XCTAssertEqual(movieUnderTest.name, "Aladdin")
        XCTAssertEqual(movieUnderTest.posterUrl, URL(string: "http://image.tmdb.org/t/p/w500"))
    }
    
    // MARK: - Async Task
    
    func testGetResponse() {
        let path = Path.API
        let parameters = ["api_key" : Path.API_KEY, "query" : "Alladin", "page" : "1"]
        
        let promise = expectation(description: "Success")
        serverRequestUnderTest.getRequest(path: path, parameters: parameters) {
            apiResult in
            if apiResult != nil {
                promise.fulfill()
            }
            else {
                XCTFail("Failed")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDataRetreivalFromRealm() {
        let realm = try! Realm()
        searchResultsUnderTest.getLastSearches()
        if let count = realm.objects(SearchList.self).first?.list.count{
            XCTAssertEqual(searchResultsUnderTest.numberOfRows, count)
        }
        else {
            XCTAssertEqual(searchResultsUnderTest.numberOfRows, 0)
        }
    }
    
}
