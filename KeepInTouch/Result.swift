//
//  Result.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failed(Error)

    var value: T? {
        guard case let .success(value) = self else {
            return nil
        }
        return value
    }

    var error: Error? {
        guard case let .failed(error) = self else {
            return nil
        }
        return error
    }
}
