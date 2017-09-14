//
//  XMLParser.swift
//  LentaSDK
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import SWXMLHash

class XMLParser<T: XMLIndexerDeserializable> {
    var nodePath: [String]
    var xml: XMLIndexer

    init(nodePath: [String], xmlData: Data) {
        self.nodePath = nodePath
        self.xml = SWXMLHash.parse(xmlData)
    }

    var object: T? {
        let targetNode = node(at: nodePath, from: xml)
        let object: T? = try? targetNode.value()
        return object
    }

    var array: [T]? {
        let targetNode = node(at: nodePath, from: xml)
        let array: [T]? = try? targetNode.value()
        return array
    }

    private func node(at path: [String], from xml: XMLIndexer) -> XMLIndexer {
        var result = xml
        path.forEach {
            result = result[$0]
        }
        return result
    }
}
