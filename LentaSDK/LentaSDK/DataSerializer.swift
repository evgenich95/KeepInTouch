//
//  DataSerializer.swift
//  LentaSDK
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
enum DataSerializer {
    static func serialize(_ value: Any) -> Data? {
        if JSONSerialization.isValidJSONObject(value) {
            return try? JSONSerialization.data(withJSONObject: value, options: [])
        } else {
            return String(describing: value).data(using: .utf8)
        }
    }
}
