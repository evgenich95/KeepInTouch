//
//  News.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import SWXMLHash

enum NewsType: String, CustomStringConvertible {
    case top7 = "top7"
    case last24 = "last24"
    case none = "news"

    var description: String {
        switch self {
        case .top7:
            return "Top Seven"
        case .last24:
            return "Past 24 hours"
        case .none:
            return "All"
        }
    }
}

class News: Object, XMLIndexerDeserializable {
    var guid: String = ""
    var title: String = ""
    var link: String = ""
    var pubDate: String = ""

    var type: NewsType = .none

    override class func ignoredProperties() -> [String] {
        return ["type"]
    }

    init(guid: String,
         title: String,
         link: String,
         pubDate: String) {
        self.guid = guid
        self.title = title
        self.link = link
        self.pubDate = pubDate
        super.init()
    }

    static func deserialize(_ node: XMLIndexer) throws -> Self {
        return try self.prase(node, self)
        //        return try self.init(
        //            guid : node["guid"].value(),
        //            title : node["title"].value(),
        //            link : node["link"].value(),
        //            pubDate : node["pubDate"].value()
        //        )
    }

    static func prase<T>(_ node: XMLIndexer, _ type: T.Type) throws -> T {
        return try News(
            guid : node["guid"].value(),
            title : node["title"].value(),
            link : node["link"].value(),
            pubDate : node["pubDate"].value()
            ) as! T

    }
}
