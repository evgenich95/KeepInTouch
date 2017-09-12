//
//  DateFormatterTests.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import XCTest
@testable import KeepInTouch

class DateFormatterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_Transform_From_String() {
        let dateStr = "Tue, 12 Sep 2017 06:51:00 +0300"
        let formatter = DateFormatterTransform()

        let date = formatter.transformFrom(dateStr)
        XCTAssertNotNil(date)

        guard let transStr = formatter.transformTo(date) else {
            XCTAssertNotNil(formatter.transformTo(date))
            return
        }
        //Not test time belt
        XCTAssertTrue(transStr.contains("Tue, 12 Sep 2017"))
    }
}
