//
//  UIConfig.swift
//  richdemo
//
//  Created by Apple on 25/1/21.
//

import KeychainAccess
import UIKit

private func isiPhoneXSeries() -> Bool {
    guard #available(iOS 11.0, *) else { return false }
    return UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
}

// 返回一个根据keychain存储的uuid
private func getChainKeyUUID() -> String {
    let account: String = "RICHAPP"
    let service = "uulD1"
    let keychain = Keychain(service: service)
    let uulD = try? keychain.getString(account)
    XLog("uulD = \(uulD ?? "")")
    if uulD != nil {
        // 如果存在，则不作任何操作
        XLog("uulD 存在：\(uulD ?? "")")
    } else {
        XLog("uulD 不存在 存储 uulD")
        // 如果不存在，则保存到keychain，
        // 利用时间戳造个假的uuid
        let nowUUID = String(Int(Date().timeIntervalSinceReferenceDate)) + String(Int.random(in: 1..<1000))
        XLog("nowUUID = \(nowUUID)")
        keychain[account] = nowUUID
    }
    let uulD2 = try? keychain.getString(account)
    return uulD2 ?? "0"
}

public extension UIDevice {
    /// 屏幕宽
    static let width = UIScreen.main.bounds.width
    /// 屏幕高
    static let height = UIScreen.main.bounds.height
    /// 是否为刘海屏
    static let iPhoneXSeries = isiPhoneXSeries()
    /// 导航栏+状态栏高度
    static let navBarHeight: CGFloat = (iPhoneXSeries ? 88 : 64)
    /// TabBar高度
    static let tabBarHeight: CGFloat = (iPhoneXSeries ? 83 : 49)
    /// 状态栏高度
    static let statusBarHeight: CGFloat = (iPhoneXSeries ? 44 : 20)
    /// 边缘间隙
    static let kMargin: CGFloat = 14
    /// Tabbar底部间隙
    static let kTabbarMargin: CGFloat = (iPhoneXSeries ? 34 : 0)
    /// ChainKeyUUID
    static let chainKeyUUID: String = getChainKeyUUID()
    /// 所有机型统一用375作为比例宽
    static func dpWidth(_ width: CGFloat ) -> CGFloat {
        return UIDevice.width / 375.0 * width
    }
}

/// 占位图 方形
public let placeholderImage = UIImage(named: "image_default", in: Localized.bundle, compatibleWith: nil)
/// 占位图 矩形
public let placeholderImageRec = UIImage(named: "image_default_rec", in: Localized.bundle, compatibleWith: nil)
/// 占位图 用户头像
public let placeholderUserIcon = UIImage(named: "user_avatar_not_login", in: Localized.bundle, compatibleWith: nil)

public let appLogoUrl = "http://rich.com/images/app/icon.png"

/// 导航栏样式
///
/// - dark: 暗色-黑色
/// - light: 亮色-白色
public enum NavigationBarStyle: Int {
    /// 默认使用系统navigation bar
    case `default`
    /// 强制控制器使用暗色-黑色
    case dark
    /// 强制控制器使用亮色-白色
    case light

    public func color() -> UIColor {
        switch self {
        case .default:
            return UIColor.clear
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.black
        }
    }
}
