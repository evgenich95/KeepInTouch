//
//  ListState.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

enum ListState<T> {
    case noData
    case loaded(T)
    case error(Error)
    case loading
}
