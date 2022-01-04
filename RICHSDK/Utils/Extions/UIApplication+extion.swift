//
//  UIApplication+extion.swift
//  RICHSDK
//
//  Created by Apple on 20/3/21.
//

import UIKit

public extension UIApplication {
    /// 获取当前topViewController
    static var topViewController: UIViewController? {
        return UIWindow.getTopViewControllerFrom(UIApplication.shared.keyWindow?.rootViewController)
    }
}

extension UIWindow {
    static func getTopViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let naviC = vc as? UINavigationController {
            return UIWindow.getTopViewControllerFrom(naviC.visibleViewController)
        } else if let tabC = vc as? UITabBarController {
            return UIWindow.getTopViewControllerFrom(tabC.selectedViewController)
        } else if let presentC = vc?.presentedViewController {
            return UIWindow.getTopViewControllerFrom(presentC)
        } else {
            return vc
        }
    }
}

public extension UIViewController {
    /// 强制横屏/竖屏
    ///
    /// - Parameter orientation: 旋转的方向 [portrait, landscapeLeft, landscapeRight]
    func forceOrientation(_ orientation: UIInterfaceOrientation) {
        UIApplication.shared.supportedInterfaceOrientations(for: UIApplication.shared.keyWindow)
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}
