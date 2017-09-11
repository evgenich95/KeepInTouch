//
//  Object.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

class Object: NSObject {

    override func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? Object {
            return self == rhs
        }
        return false
    }

    class func ignoredProperties() -> [String] {
        return []
    }

    static func == (lhs: Object, rhs: Object) -> Bool {
        return lhs.toJSONString() == rhs.toJSONString()
    }

    override var description: String {
        return toJSONString() ?? ""
    }

    func toJSON() -> [String: Any] {
        var result = [String: Any]()
        let SelfType = type(of: self)

        propertyKeys
            .filter {!SelfType.ignoredProperties().contains($0)}
            .forEach {
                if $0 == "sectionUIButton" {
                    print()
                }
                let atrrValue = value(forKey: $0)
                if let object = atrrValue as? Object {
                    result[$0] = object.toJSON()
                } else {
                    result[$0] = atrrValue
                }
        }

        return result
    }

    func toJSONString() -> String? {

        guard
            let json = toJSON() as? [String: Any],
            let data = DataSerializer.serialize(json) else {
                return nil
        }
        let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?
        return str
    }

    //    var propertyDictionary: [String: Any] {
    //        return self.toPropertyDictionary()
    //    }

    //    func toPropertyDictionary() -> [String: Any] {
    //        var dict = [String: Any]()
    //        let json = self.toJSON()
    //
    //        json.keys.forEach {
    //            dict[$0] = value(forKey: $0)
    //        }
    //        return dict
    //    }

    var propertyKeys: [String] {
        return Mirror(reflecting: self).toPropertyList()
    }

    var propertyDictionary: [String: Any] {
        return Mirror(reflecting: self).toDictionary()
    }

    func value(byAttributePath: String) -> Any? {
        guard let attributeName = byAttributePath.components(separatedBy: ".").last else {
            fatalError("Expected at least one key")
        }

        guard let object = getLastNstedObject(forKeyPath: byAttributePath) else {
            fatalError("\(self) object doenst have '\(byAttributePath)' KeyPath")
        }

        return object.value(forKey: attributeName)
    }

    func set(value: Any, toKeyPath: String) {
        guard let attributeName = toKeyPath.components(separatedBy: ".").last else {
            fatalError("Expected at least one key")
        }

        guard let object = getLastNstedObject(forKeyPath: toKeyPath) else {
            fatalError("\(self) object doenst have '\(toKeyPath)' KeyPath")
        }

        object.setValue(value, forKey: attributeName)
    }

    private func getLastNstedObject(forKeyPath: String) -> Object! {
        var keys = forKeyPath.components(separatedBy: ".")

        if keys.count == 1 {
            return self
        }

        var linkedListObject: Object? = self.value(forKey: keys.removeFirst()) as? Object

        //Remove attribute name from chain
        keys.removeLast()

        keys.forEach {
            linkedListObject = linkedListObject?.value(forKey: $0) as? Object
        }

        return linkedListObject

    }
}

extension Mirror {
    func toPropertyList() -> [String] {
        var result = [String]()
        result.append(contentsOf: self.children.flatMap {$0.label})

        // Add properties of superclass:
        if let parent = self.superclassMirror {
            result.append(contentsOf: parent.toPropertyList())
        }
        return result

    }
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()

        // Properties of this instance:
        for attr in self.children {
            if let propertyName = attr.label {
                dict[propertyName] = attr.value
            }
        }

        // Add properties of superclass:
        if let parent = self.superclassMirror {
            for (propertyName, value) in parent.toDictionary() {
                dict[propertyName] = value
            }
        }
        return dict
    }
}
