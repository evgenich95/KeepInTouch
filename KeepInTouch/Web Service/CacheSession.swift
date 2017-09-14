//
//  CacheSession.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
class CacheSession {
    static private var urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")

    static private var sessionConfiguration: URLSessionConfiguration {
        let session = URLSessionConfiguration.default
        session.requestCachePolicy = .returnCacheDataElseLoad
        session.urlCache = urlCache
        return session
    }

    static var shared: URLSession {
        return URLSession(configuration: self.sessionConfiguration)
    }

    static func cache(_ response: URLResponse, _ data: Data, for url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            let cachedResponse = CachedURLResponse(response: response, data: data, userInfo:nil, storagePolicy: URLCache.StoragePolicy.allowed)
            urlCache.storeCachedResponse(cachedResponse, for: url.request)
        }
    }
}
