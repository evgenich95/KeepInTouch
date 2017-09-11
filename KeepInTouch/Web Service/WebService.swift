//
//  WebService.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import SWXMLHash
import PromiseKit

class WebService {
    static let serverApiAddress = "https://lenta.ru/rss/"

    public typealias Completion<T> = ((_ news: Result<T>) -> Void)?

    static func loadNews(with type: NewsType) -> Promise<[News]> {
        guard let url = URL(string: serverApiAddress.appending(type.rawValue)) else {
            fatalError("Unexpected url value")
        }
        let nodePath = ["rss", "channel", "item"]

        return Downloader.shared.loadData(url: url).asArray(nodePath: nodePath)
    }
}

extension URLDataPromise {
    func asArray<T: XMLIndexerDeserializable>(nodePath: [String]) -> Promise<[T]> {
        return then(on: waldo) { data -> [T] in
            guard let array = XMLParser<T>(nodePath: nodePath, xmlData: data).array else {
                throw NetworkError(message: "Parse error")
            }
            return array
        }
    }

    func asObject<T: XMLIndexerDeserializable>(nodePath: [String]) -> Promise<T> {
        return then(on: waldo) { data -> T in
            guard let object = XMLParser<T>(nodePath: nodePath, xmlData: data).object else {
                throw NetworkError(message: "Parse error")
            }
            return object
        }
    }
}
