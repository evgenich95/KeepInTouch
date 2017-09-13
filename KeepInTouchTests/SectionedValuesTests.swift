//
//  SectionedValuesTests.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import XCTest
@testable import KeepInTouch

class SectionedValuesTests: XCTestCase {
    typealias Section = String
    typealias Value = Int

    let section1 = "Section one"
    let section2 = "Section two"
    let section3 = "Third section"

    var sectionsAndValues: [(Section, [Value])] {
        return [
            (section1, [1, 11, 21, 31]),
            (section2, [2, 22, 32]),
            (section3, [3, 33])
        ]
    }

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_Remove_Duplicates_With_Invalid_Order() {
        let data: [(Section, [Value])] = [
            (section3, [1, 11, 21, 31] + [2, 12, 22] + [3, 13, 23, 33]),
            (section2, [1, 11, 21, 31] + [2, 12, 22]),
            (section1, [1, 11, 21, 31])
        ]

        let expectedData: [(Section, [Value])] = [
            (section3, [3, 13, 23, 33]),
            (section2, [2, 12, 22]),
            (section1, [1, 11, 21, 31])
        ]

        var sectionedValues = SectionedValues<Section, Value>(data)
        let expectedSectionedValues = SectionedValues<Section, Value>(expectedData)

        sectionedValues = sectionedValues.removedDuplicates

        XCTAssertEqual(expectedSectionedValues, sectionedValues)
    }

    func test_Remove_Duplicates() {
        let data: [(Section, [Value])] = [
            (section1, [1, 11, 21, 31]),
            (section2, [1, 11, 21, 31] + [2, 12, 22]),
            (section3, [1, 11, 21, 31] + [2, 12, 22] + [3, 13, 23, 33])
        ]

        let expectedData: [(Section, [Value])] = [
            (section1, [1, 11, 21, 31]),
            (section2, [2, 12, 22]),
            (section3, [3, 13, 23, 33])
        ]

        let expectedSectionedValues = SectionedValues<Section, Value>(expectedData)

        var sectionedValues = SectionedValues<Section, Value>(data)

        //Check existing duplicates
        sectionedValues.sectionsAndValues.forEach { section, values in
            let otherValues = sectionedValues.sectionsAndValues
                .filter {$0.0 != section}
                .flatMap {$0.1}

           var matches = 0
            values.forEach {
                if otherValues.contains($0) {
                    matches += 1
                }
            }
            XCTAssertTrue(matches > 0)
        }

        sectionedValues = sectionedValues.removedDuplicates

        XCTAssertEqual(expectedSectionedValues, sectionedValues)
    }

    func test_Remove_Value() {
        var sectionedValues = SectionedValues<Section, Value>(sectionsAndValues)
        let removeItems = [(section1, 1), (section2, 2), (section3, 3)]
        var containedValues = sectionedValues.sectionsAndValues.flatMap {
            $0.1
        }

        print("sectionedValues before = \(sectionedValues)")
        //Check existing removing values
        removeItems
            .flatMap {$0.1}
            .forEach {
                XCTAssertTrue(containedValues.contains($0))
        }

        // Remove Items
        removeItems.forEach {section, value in
            sectionedValues = sectionedValues.remove(value: value, at: section)
        }

        containedValues = sectionedValues.sectionsAndValues
            .flatMap {$0.1}

        //Check missing removed values
        removeItems
            .flatMap {$0.1}
            .forEach {
                XCTAssertFalse(containedValues.contains($0))
        }

        printMe(with: [])
    }
}
