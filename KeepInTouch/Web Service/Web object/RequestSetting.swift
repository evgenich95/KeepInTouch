//
//  RequestSetting.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

struct RequestSetting {
    var isNeedCaching: Bool
    var policy: URLRequest.CachePolicy

    static let defaults = RequestSetting(isNeedCaching: false, policy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData)
}
