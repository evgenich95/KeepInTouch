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

    private var cacheSession: URLSession {
        return CacheSession.shared
    }

    private var defautlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        configuration.urlCache = nil

        return URLSession(configuration: configuration)
    }

    func loadData(url: URL, isNeedCaching: Bool = false) -> URLDataPromise {
        let cacheSession = self.cacheSession
        let session = isNeedCaching ? cacheSession : defautlSession

        let forceUpdatePromise: URLDataPromise = session.dataTask(with: url.request)
        let cachePromise: URLDataPromise = cacheSession.dataTask(with: url.request)

        return URLDataPromise { fulfill, reject in
            forceUpdatePromise.asDataAndResponse()
                .then {data, response -> Void in
                    fulfill(data)
                    CacheSession.cache(response, data, for: url)
                }.catch {_ in
                    cachePromise
                .then {data -> Void in
                    fulfill(data)
                }.catch(execute: reject)
            }
        }
    }

    func loadImage(url: URL) -> Promise<UIImage> {
        return loadData(url: url, isNeedCaching: true).asImage()
    }
}
