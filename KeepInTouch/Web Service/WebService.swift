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

public class WebService {
    static let serverApiAddress = "https://lenta.ru/rss/"

    public static func loadNews(with type: NewsType) -> Promise<[News]> {
        guard let url = URL(string: serverApiAddress.appending(type.rawValue)) else {
            fatalError("Unexpected url value")
        }
        let nodePath = ["rss", "channel", "item"]

        return Promise {fulfill, reject in
            Downloader.shared.loadData(url: url)
                .then(on: background) { data -> Void in
                    let parser = XMLParser<News>.init(nodePath: nodePath, xmlData: data)
                    guard let array = parser.array else {
                        let parseError = CustomError(message: "Parse Error")
                        reject(parseError)
                        return
                    }
                    fulfill(array)

                }.catch(execute: reject)
        }
    }

    public static func loadNews(with types: [NewsType]) -> Promise<[(NewsType, [News])]> {
        let promises = types.flatMap {loadNews(with: $0)}
        return Promise { fulfill, reject in
            firstly {
                when(fulfilled: promises)
                }.then(on: background) {results -> Void in
                    var promiseResult: [(NewsType, [News])] = []
                    for (index, news) in results.enumerated() {
                        let type = types[index]
                        news.forEach {
                            $0.type = type
                        }
                        promiseResult.append((type, news))
                    }

                    fulfill(promiseResult)
                }.catch(execute: reject)
        }
    }
}
