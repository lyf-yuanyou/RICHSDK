//
//  AppConfig.swift
//  richdemo
//
//  Created by Apple on 22/1/21.
//

import UIKit

public typealias VoidBlock = () -> Void
public typealias BoolBlock = (Bool) -> Void
public typealias IntBlock = (Int) -> Void
public typealias DoubleBlock = (Double) -> Void
public typealias StringBlock = (String) -> Void
public typealias AnyBlock = (Any) -> Void

public struct AppConfig {
    /// 系统环境
    public enum State: Int {
        /// 测试环境
        case debug
        /// 正式环境
        case release
        /// UAT环境
        case uat
    }

    /// 环境变量debug/release
    public static var state: State = .release {
        didSet {
            UserDefaults.standard.setValue(state.rawValue, forKey: UserDefaultsKey.appSystemEnv)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name.System.envChanged, object: state.rawValue, userInfo: ["state": state.rawValue])
        }
    }

    /// 应用ID：com.dotdotbuy.DotdotBuy
    public static let bundleId = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "Unknown"

    /// 应用App Store中的ID
    public static let appId = "853552552"

    /// 应用App Store中的ID
    public static let companyName = "Rich WeChat"

    /// 应用App Store中的ID
    public static let iTunesPath = "itms-apps://itunes.apple.com/app/id\(appId)"

    /// app版本号 eg:5.30.0
    public static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"

    /// app构建版本号 eg:100
    public static let buildNumber = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0") ?? 0

    /// 帮助邮箱j02358@rich.work;
    public static let helpMail = ""
}

public extension UIApplication {
    /// 应用ID：com.rich.richdemo
    static let bundleId = AppConfig.bundleId
    /// 应用App Store中的ID
    static let appId = AppConfig.appId
}
