//
//  BaseViewController.swift
//  richdemo
//
//  Created by Apple on 21/1/21.
//

import UIKit

open class BaseViewController: UIViewController {
    open var localizedTitle: String?
    open var navBarStyle: NavigationBarStyle {
        return Localized.language == .vietnam ? .dark : .light
    }
    private var lastNavBarColor: UIColor?

    override open func viewDidLoad() {
        super.viewDidLoad()
        if navigationController?.viewControllers.first != self {
            addBackButton()
        }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navBarStyle != .default {
            lastNavBarColor = navigationController?.navigationBar.tintColor
            let color = navBarStyle.color()
            navigationController?.navigationBar.tintColor = color
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
        }
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let color = lastNavBarColor {
            navigationController?.navigationBar.tintColor = color
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
            lastNavBarColor = nil
        }
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var className = self.className
        if let name = self.className.split(separator: ".").last {
            className = String(name)
        }
        // TODO: 统计
        XLog(className)
    }

    private func addBackButton() {
        let backButton = UIButton(type: .custom)
        let imageName = navBarStyle == .dark ? "nav_balck_back" : "nav_backWhite"
        backButton.setImage(UIImage(named: imageName, in: Localized.bundle, compatibleWith: nil), for: .normal)
        if #available(iOS 13.0, *) {
            let image = UIImage(named: imageName, in: Localized.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
            backButton.setImage(image, for: .normal)
        }
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 44)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc open func back() {
        if let navigationController = navigationController {
            if navigationController.viewControllers.count > 1 {
                navigationController.popViewController(animated: true)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    deinit {
        XLog("\(self.className) dealloc")
    }

    override open var shouldAutorotate: Bool {
        return false
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
