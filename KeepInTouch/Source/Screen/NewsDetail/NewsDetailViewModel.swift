//
//  NewsDetailViewModel.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13/09/2017.
//  Copyright © 2017 Anton_Ivanov. All rights reserved.
//

import Foundation

class NewsDetailViewModel {
    var title: String {
        return ""
    }

    var url: URL
    init(url: URL) {
        self.url = url
    }
}
