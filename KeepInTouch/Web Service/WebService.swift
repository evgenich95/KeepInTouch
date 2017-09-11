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

    static func loadNews(with type: NewsType) -> Promise<[News]> {
        guard let url = URL(string: serverApiAddress.appending(type.rawValue)) else {
            fatalError("Unexpected url value")
        }
        let nodePath = ["rss", "channel", "item"]

        return Promise {fulfill, reject in
            Downloader.shared.loadData(url: url).then { data -> Void in
                let parser = XMLParser<News>.init(nodePath: nodePath, xmlData: data)
                guard let array = parser.array else {
                    let parseError = NetworkError(message: "Parse Error")
                    reject(parseError)
                    return
                }
                fulfill(array)

                }.catch(execute: reject)
        }
    }
}
