//
//  Localized.swift
//  richdemo
//
//  Created by Apple on 26/1/21.
//

import Foundation
import MJRefresh

/// 语言
public enum Language: String {
    /// 英文🇺🇸
    case english = "en"
    /// 中文🇨🇳
    case chinese = "zh"
    /// 越南语🇻🇳
    case vietnam = "vi"

    /// 语言描述
    public func description() -> String {
        switch self {
        case .english:
            return "English"
        case .chinese:
            return "中文"
        case .vietnam:
            return "越南语"
        }
    }

    /// Locale
    public func locale() -> String {
        switch self {
        case .english:
            return "en-US"
        case .chinese:
            return "zh-CN"
        case .vietnam:
            return "vi-VN"
        }
    }
}

/// 国际化支持
public class Localized {
    /// RICHSDK.framework bundle
    public static let bundle = Bundle(for: Localized.self)
    /// language bundle
    fileprivate static var langBundle = Bundle.main
    /// 支持的语言[.english, .chinese]
    public static let supportLanguages: [Language] = [.english, .chinese, .vietnam]

    /// AppDelegate中初始化
    public static func initConfig() {
        let supportLanguages = Localized.supportLanguages.compactMap({ $0.rawValue })
        if let lang = UserDefaults.standard.string(forKey: UserDefaultsKey.appLang), supportLanguages.contains(lang) {
            XLog("用户保存的语言：\(lang)")
            setLang(Language(rawValue: lang)!)
        } else if let lang = Locale.current.languageCode, supportLanguages.contains(lang) {
            XLog("系统语言：\(lang)")
            setLang(Language(rawValue: lang)!)
        } else {
            setLang(Language(rawValue: "en")!)
        }
    }
    /// 设置语言
    public static func setLang(_ lang: Language) {
        if !Localized.supportLanguages.contains(lang) {
            return
        }
        if let path = langBundle.path(forResource: lang.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) {
            langBundle = bundle
        } else {
            langBundle = Bundle.main
        }
        MJRefreshConfig.default().languageCode = lang.rawValue
        UserDefaults.standard.setValue(lang.rawValue, forKey: UserDefaultsKey.appLang)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: Notification.Name.System.langChanged, object: lang.rawValue, userInfo: ["lang": lang.rawValue])
    }
    /// 当前语言
    public static var language: Language {
        return Language(rawValue: UserDefaults.standard.string(forKey: UserDefaultsKey.appLang) ?? "en")!
    }
}

public extension String {
    /// 获取本地化字符串
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Localized.langBundle, value: "", comment: "")
    }
}

extension String {
    /// 获取RICHSDK.framework字符串
    func sdkLocalized() -> String {
        if let path = Localized.bundle.path(forResource: Localized.language.rawValue, ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        }
        return self.localized()
    }
}
