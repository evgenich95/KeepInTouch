//
//  ObjectBuilder.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
public func build<T>(_ object: T, _ initializer: (T) -> Void) -> T {
    initializer(object)
    return object
}
