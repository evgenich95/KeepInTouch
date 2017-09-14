//
//  SimpleNewsCollectionViewCell.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import UIKit
import LentaSDK

class SimpleNewsCollectionViewCell: SingleItemCollectionCell<News> {

    @IBOutlet weak var contentUIView: UIView!
    @IBOutlet weak var newsTitle: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addBottomBorder(color: .lightGray, width: 0.5)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    private let dateFormatter = build(DateFormatter()) {
        $0.locale = Locale(identifier: "en_US_POSIX")
        $0.dateFormat = "HH:mm"
    }

    override func updateUI(with object: News) {
        let dateStr = dateFormatter.string(from: object.pubDate)
        let labelText = "\(dateStr) \(object.title)"

        let attributedText = build(NSMutableAttributedString(string: labelText)) {
            let range = NSRange(location: 0, length: dateStr.characters.count)
            $0.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
        }

        newsTitle.attributedText = attributedText
    }
}
