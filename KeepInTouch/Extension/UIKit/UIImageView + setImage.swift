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
        return make(UIActivityIndicatorView(activityIndicatorStyle: .gray)) {
            let ownFrame = $0.frame
            let containerView = self.frame

            let x = containerView.width / 2 - ownFrame.width / 2
            let y = containerView.height / 2 + ownFrame.height / 2

            $0.frame = CGRect(origin: CGPoint(x:  x, y: y), size: ownFrame.size)

            $0.hidesWhenStopped = true
            addSubview($0)
        }
    }

    func setImage(url: URL, completion: Downloader.Completion<UIImage> = nil) {
        image = nil
        let progressIndicator = activityIndicator

        main.async {
            progressIndicator.startAnimating()
        }

        Downloader.shared.loadImage(url: url)
            .then(on: main) {[weak self] image -> Void in
                self?.image = image
            }.always(on: main) {
                progressIndicator.stopAnimating()
                progressIndicator.removeFromSuperview()

        }
    }
}
