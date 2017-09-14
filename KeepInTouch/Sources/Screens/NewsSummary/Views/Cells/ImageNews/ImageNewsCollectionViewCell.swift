//
//  ImageNewsCollectionViewCell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import UIKit
import LentaSDK

class ImageNewsCollectionViewCell: SingleItemCollectionCell<News> {

    @IBOutlet weak var newsTitleUILabel: UILabel!
    @IBOutlet weak var newsUIImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        newsUIImageView.image = nil
        newsUIImageView.isHidden = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addBottomBorder(color: .lightGray, width: 0.5)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        newsUIImageView.contentMode = .scaleAspectFit
    }

    override func updateUI(with object: News) {
        if let url = object.url {
            newsUIImageView.setImage(url: url)
        } else {
            newsUIImageView.isHidden = true
        }
        newsTitleUILabel.text = object.title
    }
}
