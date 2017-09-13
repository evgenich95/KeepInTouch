//
//  LabelView.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class LabelView: UIView {
    private let label = make(UILabel()) {
        $0.adjustsFontSizeToFitWidth = true
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.minimumScaleFactor = 0.6
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = frame
        label.center = CGPoint(x: frame.width / 2,
                               y: frame.height / 2)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }

    private func createView() {
        addSubview(label)
    }

    func set(error: Error, color: UIColor = .red) {
        label.text = error.localizedDescription
        label.textColor = color
    }
    func set(text: String, color: UIColor = .darkGray) {
        label.text = text
        label.textColor = color
    }
}
