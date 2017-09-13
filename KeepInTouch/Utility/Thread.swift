//
//  Thread.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

internal let main = DispatchQueue.main
internal var background = DispatchQueue.global(qos: .userInitiated)
internal let utility = DispatchQueue.global(qos: .utility)
