//
//  SectionedValues.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
public struct SectionedValues<Section: Equatable, Value: Equatable>: Equatable {

    typealias TableViewData = SectionedValues<Section, TableCellData<Value>>
    typealias CollectionViewData = SectionedValues<Section, CollectionCellData<Value>>

    public var isEmpty: Bool {
        return  sectionsAndValues.flatMap {$0.1}.isEmpty
    }
    public init(_ sectionsAndValues: [(Section, [Value])] = []) {
        self.sectionsAndValues = sectionsAndValues
    }

    public var sectionsAndValues: [(Section, [Value])]

    internal var sections: [Section] { get { return self.sectionsAndValues.map { $0.0 } } }

    func value(for indexPath: IndexPath) -> Value {
        return sectionsAndValues[indexPath.section].1[indexPath.row]
    }

    public func appending(sectionAndValue: (Section, [Value])) -> SectionedValues<Section, Value> {
        return SectionedValues(self.sectionsAndValues + [sectionAndValue])
    }

    func tableViewData(valueToCellType: @escaping ((Value) -> SingleItemTableCell<Value>.Type)) -> TableViewData {
        var data = TableViewData()
        sectionsAndValues.forEach { section, objectArray in
            let cells = objectArray.flatMap { (value: Value) in
                TableCellData(value, valueToCellType(value))
            }
            data = data.appending(sectionAndValue: (section, cells))
        }
        return data
    }

    func collectionViewData(valueToCellType: @escaping ((Value) -> SingleItemCollectionCell<Value>.Type)) -> CollectionViewData {
        var data = CollectionViewData()
        sectionsAndValues.forEach { section, objectArray in
            let cells = objectArray.flatMap { (value: Value) in
                CollectionCellData(value, valueToCellType(value))
            }
            data = data.appending(sectionAndValue: (section, cells))
        }
        return data
    }

    var withoutDuplicates: SectionedValues<Section, Value> {
        var handlingSections = sections
        var updatedSectionsAndValues = SectionedValues<Section, Value>(sectionsAndValues)

        //For all Sections
        sectionsAndValues
            //Sort by values count
            .sorted {$0.1.count < $1.1.count}
            .forEach { section, values in
                if let index = handlingSections.index(of: section) {
                    handlingSections.remove(at: index)
                }
                //Remove all found value matches from other sections
                values.forEach {value in
                    handlingSections.forEach { targetSection in
                        updatedSectionsAndValues = updatedSectionsAndValues.remove(value: value, at: targetSection)
                    }
                }
        }
        return updatedSectionsAndValues
    }

    func remove(value: Value, at section: Section) -> SectionedValues<Section, Value> {
        var sectionsAndValues = self.sectionsAndValues

        guard let itemIndex = sectionsAndValues.index(where: {$0.0 == section}) else {
            return self
        }
        //Get (Section, [Value]) under consideration
        var targetValues = sectionsAndValues[itemIndex].1

        //Replace by updated value Array
        if let removeValueIndex = targetValues.index(of: value) {
            targetValues.remove(at: removeValueIndex)
            sectionsAndValues[itemIndex] = (section, targetValues)
        }
        return SectionedValues<Section, Value>(sectionsAndValues)
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
