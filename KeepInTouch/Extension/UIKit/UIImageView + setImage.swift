//
//  UIImageView + setImage.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    var activityIndicator: UIActivityIndicatorView {

        let activityIndicator = make(UIActivityIndicatorView(activityIndicatorStyle: .gray)) {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addSubview(activityIndicator)

        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)

        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

        addConstraint(horizontalConstraint)
        addConstraint(verticalConstraint)

        return activityIndicator
    }

    func setImage(url: URL, completion: ((_ image: UIImage?) -> Void)? = nil) {
        image = nil
        let progressIndicator = activityIndicator

        main.async {
            progressIndicator.startAnimating()
        }

        Downloader.shared.loadImage(url: url)
            .then(on: main) {[weak self] image -> Void in
                self?.image = image
                completion?(image)
            }.catch { (_) in
                completion?(nil)
            }.always(on: main) {
                progressIndicator.stopAnimating()
                progressIndicator.removeFromSuperview()
        }
    }
}
