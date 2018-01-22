//
//  KeepInTouchUITests.swift
//  KeepInTouchUITests
//
//  Created by iae on 1/16/18.
//  Copyright © 2018 IAE. All rights reserved.
//

import XCTest
import UIKit
@testable import KeepInTouch

class KeepInTouchUITests: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        app = XCUIApplication()
        
        // We send a command line argument to our app,
        // to enable it to reset its state
        app.launchArguments.append("--uitesting")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func waitForElementToAppear(_ element: XCUIElement) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testOpenAndCloseNews() {
        app.launch()
        
        // Check that NewsSummary screen is displaying now
        // But not NewsDetails screen
        XCTAssertTrue(app.isDisplayingNewsSummary)
        XCTAssertFalse(app.isDisplayingWebView)
        
        //Wait when first news is appered
        self.waitForElementToAppear(app.collectionViews.firstMatch.cells.firstMatch)

        //Check that table has more than 0 news
        XCTAssertTrue(app.collectionViews.firstMatch.cells.count > 0)
        
        //Wait for 3 second and open details of the first news
        // in the table
        execute(after: 3.0) {
            self.app.collectionViews.firstMatch.cells.firstMatch.tap()
        }
        
        // Check that NewsDetails screen is displaying now
        // But not NewsSummary screen
        execute(after: 3.0) {
            XCTAssertFalse(self.app.isDisplayingNewsSummary)
            XCTAssertTrue(self.app.isDisplayingWebView)
        }
        
        // Screen must have Done button
        // which shoud return us to the NewsSummary screen
        execute(after: 3.0) {
            self.app.buttons["Done"].tap()
        }
        
        // Check that NewsSummary screen is displaying now
        // But not NewsDetails screen
        XCTAssertTrue(app.isDisplayingNewsSummary)
        XCTAssertFalse(app.isDisplayingWebView)
    }
    
    // Help function
    func execute(after delay: TimeInterval, block: @escaping () -> Void) {
        let exp = expectation(description: #function)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
            exp.fulfill()
        }
        
        waitForExpectations(timeout: delay + 5.0)
    }
    
}

extension XCUIApplication {
    var isDisplayingNewsSummary: Bool {
        return otherElements["NewsSummaryViewController"].exists
    }
    
    var isDisplayingWebView: Bool {
        return otherElements["WebView"].exists
    }
}

