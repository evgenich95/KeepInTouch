//
//  SectionedValues.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
public struct SectionedValues<Section: Equatable, Value: Equatable>: Equatable {

    public init(_ sectionsAndValues: [(Section, [Value])] = []) {
        self.sectionsAndValues = sectionsAndValues
    }

    public let sectionsAndValues: [(Section, [Value])]

    internal var sections: [Section] { get { return self.sectionsAndValues.map { $0.0 } } }
//    internal subscript(i: Int) -> (Section, [Value]) {
//        return self.sectionsAndValues[i]
//    }

    func value(for indexPath: IndexPath) -> Value {
        return sectionsAndValues[indexPath.section].1[indexPath.row]
    }

    public func appending(sectionAndValue: (Section, [Value])) -> SectionedValues<Section, Value> {
        return SectionedValues(self.sectionsAndValues + [sectionAndValue])
    }

    public static func ==(lhs: SectionedValues<Section, Value>, rhs: SectionedValues<Section, Value>) -> Bool {
        guard lhs.sectionsAndValues.count == rhs.sectionsAndValues.count else { return false }
        for i in 0..<(lhs.sectionsAndValues.count) {
            let ltuple = lhs.sectionsAndValues[i]
            let rtuple = rhs.sectionsAndValues[i]
            if (ltuple.0 != rtuple.0 || ltuple.1 != rtuple.1) {
                return false
            }
        }
        return true
    }
}

public extension SectionedValues where Section: Hashable {
    public init(
        values: [Value],
        valueToSection: ((Value) -> Section),
        sortSections: ((Section, Section) -> Bool),
        sortValues: ((Value, Value) -> Bool)) {
        var dictionary = [Section: [Value]]()
        for value in values {
            let section = valueToSection(value)
            var current = dictionary[section] ?? []
            current.append(value)
            dictionary[section] = current
        }
        
        let sortedSections = dictionary.keys.sorted(by: sortSections)
        self.init(sortedSections.map { section in
            let values = dictionary[section] ?? []
            let sortedValues = values.sorted(by: sortValues)
            return (section, sortedValues)
        })
    }
}

public extension SectionedValues where Section: Hashable {
    public init(
        dictionary: [Section: [Value]],
        sortSections: ((Section, Section) -> Bool),
        sortValues: ((Value, Value) -> Bool)) {

        let sortedSections = dictionary.keys.sorted(by: sortSections)

        self.init(sortedSections.map { section in
            let values = dictionary[section] ?? []
            let sortedValues = values.sorted(by: sortValues)
            return (section, sortedValues)
        })
    }
}
