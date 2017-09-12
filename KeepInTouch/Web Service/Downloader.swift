//
//  Downloader.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit
import SWXMLHash
import PromiseKit

extension URL {
    var request: URLRequest {
        return URLRequest(url: self, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 30.0)
    }
}

class Downloader: NSObject, URLSessionTaskDelegate {

    static let shared = Downloader()

    public typealias Completion<T> = ((_ result: Result<T>) -> Void)?

    private var urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")

    private lazy var sessionConfiguration: URLSessionConfiguration = {
        return make(URLSessionConfiguration.default) {
            $0.requestCachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
            $0.urlCache = self.urlCache
        }
    }()

    private lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration, delegate: self, delegateQueue: nil)
    }()

    func loadData(url: URL, setting: RequestSetting = RequestSetting.defaults) -> URLDataPromise {
        printMe(with: ["url = \(url)"])

        session.configuration.requestCachePolicy = setting.policy
        let dataPromise: URLDataPromise = session.dataTask(with: url.request)
        _ = dataPromise.asDataAndResponse().then(on: background) {[weak self] data, response -> Void in
            if setting.isNeedCaching {
                self?.cache(response, data, for: url)
            }
        }
        return dataPromise
    }

    func loadImage(url: URL) -> Promise<UIImage> {
        printMe(with: ["url = \(url)"])

        let setting = RequestSetting(isNeedCaching: true, policy: .returnCacheDataElseLoad)
        return loadData(url: url, setting: setting).asImage()
    }

    private func cache(_ response: URLResponse, _ data: Data, for url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            let cachedResponse = CachedURLResponse(response: response, data: data, userInfo:nil, storagePolicy: URLCache.StoragePolicy.allowed)
            self?.urlCache.storeCachedResponse(cachedResponse, for: url.request)
            printMe(with: ["cached"])
        }
    }
}
