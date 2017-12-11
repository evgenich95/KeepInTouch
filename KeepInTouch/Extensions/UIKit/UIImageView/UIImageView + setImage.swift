//
//  UIImageView + setImage.swift
//  LentaSDK
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit
import LentaSDK

extension UIImageView {
    private var activityIndicator: UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)

        let horizontalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)

        let verticalConstraint = NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

        addConstraint(horizontalConstraint)
        addConstraint(verticalConstraint)

        return activityIndicator
    }

    public func setImage(url: URL, completion: ((_ image: UIImage?) -> Void)? = nil) {
        let progressIndicator = activityIndicator
        let main = DispatchQueue.main
        main.async {
            self.image = nil
            progressIndicator.startAnimating()
        }

        Downloader.shared.loadImage(url: url)
            .then(on: .main) {[weak self] image -> Void in
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
