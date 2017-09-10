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

    func loadObject<T: XMLIndexerDeserializable>(url: URL, nodePath: [String], completion: Completion<T>) {
        loadData(url: url) { (result) in
            switch result {
            case .success(let data):
                guard let object = XMLParser<T>(nodePath: nodePath, xmlData: data).object else {
                    completion?(.failed(NetworkError(message: "Parse error")))
                    return
                }
                completion?(.success(object))
            case .failed(let error):
                completion?(.failed(error))
            }
        }
    }

    func loadArray<T: XMLIndexerDeserializable>(url: URL, nodePath: [String], completion: Completion<[T]>) {
        loadData(url: url) { (result) in
            switch result {
            case .success(let data):
                guard let array = XMLParser<T>(nodePath: nodePath, xmlData: data).array else {
                    completion?(.failed(NetworkError(message: "Parse error")))
                    return
                }
                completion?(.success(array))
            case .failed(let error):
                completion?(.failed(error))
            }
        }
    }

    private func loadData(url: URL, setting: RequestSetting = RequestSetting.defaults, completion: Completion<Data>) {
        session.configuration.requestCachePolicy = setting.policy
        let task = session.dataTask(with: url.request) {[weak self] (data, response, error) in
            guard
                let data = data,
                let response = response
                else {
                    let defaultError = NetworkError(message: "Did not receive data")
                    completion?(.failed(error ?? defaultError))
                    return
            }

            completion?(.success(data))
            if setting.isNeedCaching {
                self?.cache(response, data, for: url)
            }
        }

        task.resume()
    }

    private func cache(_ response: URLResponse, _ data: Data, for url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            let cachedResponse = CachedURLResponse(response: response, data: data, userInfo:nil, storagePolicy: URLCache.StoragePolicy.allowed)
            self?.urlCache.storeCachedResponse(cachedResponse, for: url.request)
        }
    }
}
