//
//  NetworkError.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

struct NetworkError: Error {
    var message: String

    var localizedDescription: String {
        return message
    }
}
