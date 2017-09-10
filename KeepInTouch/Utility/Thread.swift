//
//  Thread.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

public let main = DispatchQueue.main
public var background = DispatchQueue.global(qos: .userInitiated)
public let utility = DispatchQueue.global(qos: .utility)
