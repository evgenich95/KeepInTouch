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
        layer.borderWidth = 0.25
        layer.borderColor = UIColor.red.cgColor
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

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}
