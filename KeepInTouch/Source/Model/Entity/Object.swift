//
//  Object.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import SWXMLHash

public class Object: NSObject, XMLIndexerDeserializable {

    override public func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? Object {
            return self == rhs
        }
        return false
    }

    public static func deserialize(_ node: XMLIndexer) throws -> Self {
        return try self.prase(node, self)
    }

    class func prase<T>(_ node: XMLIndexer, _ type: T.Type) throws -> T {
        fatalError("'\(self)' class must implement prase(_:) function")
    }

    class func ignoredProperties() -> [String] {
        return []
    }

    static func == (lhs: Object, rhs: Object) -> Bool {
        return lhs.toJSONString() == rhs.toJSONString()
    }

    override public var description: String {
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

    var propertyKeys: [String] {
        return Mirror(reflecting: self).toPropertyList()
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
