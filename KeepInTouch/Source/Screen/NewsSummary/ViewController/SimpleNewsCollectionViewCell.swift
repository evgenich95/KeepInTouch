//
//  SimpleNewsCollectionViewCell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import UIKit

class SimpleNewsCollectionViewCell: SingleItemCollectionCell<News> {

    @IBOutlet weak var contentUIView: UIView!
    @IBOutlet weak var newsTitle: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addBottomBorder(color: .gray, width: 1)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    let dateFormatter = make(DateFormatter()) {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "HH:mm"
    }

    override func updateUI(by object: News) {
        let dateStr = dateFormatter.string(from: object.pubDate)
        let labelText = "\(dateStr) \(object.title)"

        let attributedText = make(NSMutableAttributedString(string: labelText)) {
            let range = NSRange(location: 0, length: dateStr.characters.count)
            $0.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
        }

        newsTitle.attributedText = attributedText
    }
}
