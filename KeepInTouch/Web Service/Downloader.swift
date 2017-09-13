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

class CacheSession {
    static private var urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")

    static private var sessionConfiguration: URLSessionConfiguration {
        return make(URLSessionConfiguration.default) {
            $0.requestCachePolicy = URLRequest.CachePolicy.returnCacheDataElseLoad
            $0.urlCache = urlCache
        }
    }

    static var shared: URLSession {
        return URLSession(configuration: self.sessionConfiguration)
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
        let url2 = URL(string: "https://gist.githubusercontent.com/evgenich95/652d81d762e1ae0d5583a42c50660428/raw/89effcbed21aa0ad527da87e4fea9e800d5e591b/gistfile1.txt")!

        var baseurl = url2
        if isNeedCaching {
            baseurl = url
        }
        let session = isNeedCaching ? cacheSession : defautlSession

        //Backup caching each request
        let _ : URLDataPromise = cacheSession.dataTask(with: baseurl.request)

        return URLDataPromise { fulfill, reject in
            let dataPromise: URLDataPromise = session.dataTask(with: baseurl.request)

            dataPromise.then { data -> Void in
                fulfill(data)
                }.catch { _ -> Void in
                    let cachePromise: URLDataPromise = cacheSession.dataTask(with: baseurl.request)

                    cachePromise.then { data -> Void in
                        fulfill(data)
                        }.catch(execute: reject)
            }
        }

    }

    func loadImage(url: URL) -> Promise<UIImage> {
        return loadData(url: url, isNeedCaching: true).asImage()
    }
}
