//
//  WebService.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import SWXMLHash

class WebService {
    static let serverApiAddress = "https://lenta.ru/rss/"

    public typealias Completion<T> = ((_ news: Result<T>) -> Void)?

    static func loadNews(with type: NewsType, completion: Completion<[News]>) {
        guard let url = URL(string: serverApiAddress.appending(type.rawValue)) else {
            fatalError("Unexpected url value")
        }
        let nodePath = ["rss", "channel", "item"]

        Downloader.shared.loadArray(url: url, nodePath: nodePath, completion: completion)
    }
}
