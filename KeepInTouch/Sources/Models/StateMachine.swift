//
//  StateMachine.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 14.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation

protocol StateMachine {
    associatedtype Owner: NSObject
    associatedtype Content

    typealias State = ListState<Content>

    var state: State {get set}
    weak var owner: Owner? {get set}

    init()
    init(owner: Owner)

    func `switch`(to state: State)
}

extension StateMachine {
    init(owner: Owner) {
        self.init()
        self.owner = owner
    }
}
