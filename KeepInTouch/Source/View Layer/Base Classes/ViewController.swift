//
//  ViewController.swift
//  KeepInTouch
//
//  Created by Anton Ivanov on 10.09.17.
//  Copyright © 2017 IAE. All rights reserved.
//

import Foundation
import UIKit

public typealias EmptyFunction = () -> Void

//TODO: Deelte unused functions
class ViewController: UIViewController {

    init() {
        let nibName = String(describing: type(of: self))
        super.init(nibName: nibName, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var closeEditingByEmptySpaceTapping: Bool = false {
        didSet {
            if closeEditingByEmptySpaceTapping {
                view.addGestureRecognizer(oneTapGestureRecognizer)
            } else {
                view.removeGestureRecognizer(oneTapGestureRecognizer)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if closeEditingByEmptySpaceTapping {
            view.addGestureRecognizer(oneTapGestureRecognizer)
        }
    }

    internal func setupView() {
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        automaticallyAdjustsScrollViewInsets = false
    }

    private lazy var oneTapGestureRecognizer: UITapGestureRecognizer = {
        let doubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(self.handleOneTap)
        )
        doubleTap.numberOfTapsRequired = 1
        return doubleTap
    }()

    // MARK: AddTarget's Actions
    @objc private func handleOneTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    lazy var emptyListBacgroundView: UIView = {
        let view = UIView(frame: self.view.frame)
        let label = UILabel()
        label.text = "Список пуст"
        label.textColor = UIColor.darkGray
        view.addSubview(label)
//        label.snp.makeConstraints { make in
//            make.centerX.centerY.equalTo(view)
//        }
        return view

    }()
}

extension UIViewController {
    func showNotificationAlert(withTitle: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: withTitle, message:
            message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            completion?()
        }
        alertController.addAction(action)

        DispatchQueue.main.async {[weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }

}
