//
//  BaseNavController.swift
//  richdemo
//
//  Created by Apple on 21/1/21.
//

import UIKit

open class BaseNavController: UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        if Localized.language == .vietnam {
            navigationBar.setBackgroundImage(UIImage(named: "nav_bar_white", in: Localized.bundle, compatibleWith: nil), for: .default)
            navigationBar.isTranslucent = true
            navigationBar.shadowImage = UIImage()
            navigationBar.layer.masksToBounds = false
            navigationBar.layer.shadowColor = UIColor.hex(0x000000, 0.09).cgColor
            navigationBar.layer.shadowOpacity = 1
            navigationBar.layer.shadowRadius = 8
            navigationBar.layer.shadowOffset = CGSize(width: 0, height: 4)
            navigationBar.tintColor = UIColor.black
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        } else {
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
            navigationBar.tintColor = UIColor.white
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
}
