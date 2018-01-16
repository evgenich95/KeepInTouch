//
//  WebServiceTests.swift
//  LentaSDKTests
//
//  Created by iae on 1/16/18.
//  Copyright © 2018 IAE. All rights reserved.
//

import XCTest
@testable import LentaSDK

class WebServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testloadTop7News() {
        let exp = expectation(description: #function)
        
        WebService.loadNews(with: .top7).then { news in
            XCTAssertTrue(news.count == 7)
            }.catch { (error) in
                XCTAssertTrue(false, "Loading of top 7 news is failed with error: \(error)")
            }.always {
                exp.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testloadLast24News() {
        let exp = expectation(description: #function)
        
        WebService.loadNews(with: .last24).then { news in
            XCTAssertTrue(news.count > 0)
            }.catch { (error) in
                XCTAssertTrue(false, "Loading of last24 news is failed with error: \(error)")
            }.always {
                exp.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
    
    func testloadAllNews() {
        let exp = expectation(description: #function)
        
        WebService.loadNews(with: .none).then { news in
            XCTAssertTrue(news.count > 7)
            }.catch { (error) in
                XCTAssertTrue(false, "Loading of All news is failed with error: \(error)")
            }.always {
                exp.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
    }
}
