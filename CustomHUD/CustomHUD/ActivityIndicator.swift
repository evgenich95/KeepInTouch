//
//  ActivityIndicator.swift
//  CustomHUD
//
//  Created by Anton Ivanov on 13.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator: UIView {
    var style: UIActivityIndicatorViewStyle = .whiteLarge
    var color: UIColor?

    lazy private var activityIndicator: UIActivityIndicatorView =  {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: self.style)
        activity.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activity.color = self.color
        activity.hidesWhenStopped = true
        return activity
    }()

    init(style: UIActivityIndicatorViewStyle = .whiteLarge, color: UIColor? = nil) {
        self.style = style
        self.color = color
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        createView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }

    private func createView() {
        backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha: 0.5)
        clipsToBounds = true
        layer.cornerRadius = 10
        activityIndicator.center = CGPoint(x: frame.size.width / 2,
                                           y: frame.size.height / 2)
        addSubview(activityIndicator)
    }

    func show(at view: UIView, animated: Bool) {
        center = view.center
        view.addSubview(self)
        self.activityIndicator.startAnimating()

        if animated {
            transform = CGAffineTransform(scaleX: 0, y: 0)
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }

    func hide(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
            }, completion: {_ in
                self.activityIndicator.stopAnimating()
                self.removeFromSuperview()
            })
        } else {
            activityIndicator.stopAnimating()
            removeFromSuperview()
        }
    }
}
