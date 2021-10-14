//
//  ModelDataTests.swift
//  ShukraUnitTests
//
//  Created by Alok Irde on 10/14/21.
//

import XCTest
@testable import Shukra

class ModelDataTests: XCTestCase {
    var apiKey: String!
    var path: String!
    var mimeTypes: [String]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiKey = "QpaRwg94lcrw75Befex6xRahvMdwbypgZa2MtROY"
        path = "https://api.nasa.gov/planetary/apod?api_key="+apiKey
        mimeTypes = ["image/png", "image/jpg", "image/jpeg", "text/html", "text/json"]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRouterLoad() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let mimeTypes = self.mimeTypes
        Router.shared.load(url: path) { dataOrNil, mimeTypeOrNil, errorOrNil in
            XCTAssert(errorOrNil == nil, "Error response received on load \(errorOrNil!)")
            XCTAssertTrue((mimeTypes?.contains(mimeTypeOrNil!))!)
            XCTAssert(dataOrNil != nil, "Invalid Data received")
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
