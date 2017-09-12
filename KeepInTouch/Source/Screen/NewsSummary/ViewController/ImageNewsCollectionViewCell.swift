//
//  ImageNewsCollectionViewCell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import UIKit

class ImageNewsCollectionViewCell: SingleItemCollectionCell<News> {

    @IBOutlet weak var descriptionUILabel: UILabel!
    @IBOutlet weak var newsTitleUILabel: UILabel!
    @IBOutlet weak var newsUIImageView: UIImageView!

    override func prepareForReuse() {
        newsUIImageView.image = nil
        newsUIImageView.isHidden = false
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addBottomBorderWithColor(color: .gray, width: 1)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        newsUIImageView.contentMode = .scaleAspectFit
    }

    override func updateUI(by object: News) {
        if let url = object.url {
            newsUIImageView.setImage(url: url)
        } else {
            newsUIImageView.isHidden = true
        }
        newsTitleUILabel.text = object.title
        descriptionUILabel.text = object.definition.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)

    }
}
