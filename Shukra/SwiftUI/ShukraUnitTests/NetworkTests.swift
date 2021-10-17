//
//  NetworkTests.swift
//  ShukraUnitTests
//
//  Created by Sadyojat on 10/14/21.
//

import XCTest
@testable import Shukra

// MARK: Legacy tests ( iOS 14.x )
class NetworkTests: XCTestCase {

    var downloadImageUrl: String!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        downloadImageUrl = "https://Apod.nasa.gov/Apod/image/2110/NGC289Selby1024.jpg"
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    
    func testPODFetch() {
        NetworkInteractor.fetchPODData { pictureOrNil, errorOrNil in
            XCTAssertNotNil(pictureOrNil)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}


// MARK: NEW ( iOS 15.x ) Async Await test scenarios for router code
@available(iOS 15.0.0, *)
extension NetworkTests {
    func testAsyncPODFetch() throws {
        Task {
            let picture = try await NetworkInteractor.fetchPODDataWithAsyncURLSession()
            XCTAssertNotNil(picture)
        }
    }
    
    func testAsyncImageFetch() throws {
        Task {
            let image = try await NetworkInteractor.fetchAsyncImage(URL(string: downloadImageUrl)!)
            XCTAssertNotNil(image)
        }
    }
    
}
