//
//  ObjectBuilder.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 14.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
internal func make<T>(_ object: T, _ initializer: (T) -> Void) -> T {
    initializer(object)
    return object
}
