//
//  CustomError.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

struct CustomError: LocalizedError {
    var message: String

    var errorDescription: String? {
        return message
    }
}
