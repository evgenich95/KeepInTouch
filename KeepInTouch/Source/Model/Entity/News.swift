//
//  News.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import SWXMLHash

public enum NewsType: String, CustomStringConvertible {
    case top7 = "top7"
    case last24 = "last24"
    case none = "news"

    public var description: String {
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

public class News: Object {
    public var guid = ""
    public var title = ""
    public var link = ""
    public var pubDate = Date()
    public var definition = ""
    public var url: URL?

    public var type: NewsType = .none

    override class func ignoredProperties() -> [String] {
        return ["type"]
    }

    public init(guid: String, title: String, link: String, pubDate: Date, definition: String, url: URL?) {
        self.guid = guid
        self.title = title
        self.link = link
        self.pubDate = pubDate
        self.definition = definition
        self.url = url

        super.init()
    }

    override class func prase<T>(_ node: XMLIndexer, _ type: T.Type) throws -> T {

        let dateStr: String = try node["pubDate"].value()
        guard let date = DateFormatterTransform().transformFrom(dateStr) else {
            throw IndexingError.attribute(attr: "pubDate")
        }

        let urlStr = node["enclosure"].element?.attribute(by: "url")?.text
        let url = URL(string: urlStr ?? "")

        return try News(
            guid : node["guid"].value(),
            title : node["title"].value(),
            link : node["link"].value(),
            pubDate : date,
            definition: node["description"].value(),
            url: url
            ) as! T
    }
}
