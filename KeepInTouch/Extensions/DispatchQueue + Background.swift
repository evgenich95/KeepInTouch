//
//  DispatchQueue + Background.swift
//  KeepInTouch
//
//  Created by iae on 12/11/17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static let background = DispatchQueue.global(qos: .userInitiated)
}
