//
//  NewsSummaryHeader.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 11.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import UIKit

class NewsSummaryHeader: UICollectionReusableView {

    @IBOutlet weak var headerNameUILabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!

    private var viewAction: EmptyFunction?
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.00)
    }

    func updateUI(headerName: String, viewAction: EmptyFunction?) {
        headerNameUILabel.text = headerName
        self.viewAction = viewAction
    }
    
    @IBAction func viewAction(_ sender: UIButton) {
        viewAction?()
    }
}
