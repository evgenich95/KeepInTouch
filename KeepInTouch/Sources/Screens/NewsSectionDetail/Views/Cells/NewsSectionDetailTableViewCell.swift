//
//  NewsSectionDetailTableViewCell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 12.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import UIKit
import LentaSDK

class NewsSectionDetailTableViewCell: SingleItemTableCell<News> {

    @IBOutlet weak var newsTitleUILabel: UILabel!
    @IBOutlet weak var newsUIImageView: UIImageView!
    @IBOutlet weak var newsDescriptionUILabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        newsUIImageView.image = nil
        newsUIImageView.isHidden = false
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
        newsDescriptionUILabel.text = object.definition.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
    }
}
