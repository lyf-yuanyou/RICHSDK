//
//  NotificationKey.swift
//  richdemo
//
//  Created by Apple on 30/1/21.
//

import Foundation

public extension Notification.Name {
    /// 系统相关通知
    struct System {
        /// 系统上报日志
        public static let reportRecord = Notification.Name(rawValue: "rich.system.reportRecord")
        /// 系统环境改变 test/super/release
        public static let envChanged = Notification.Name(rawValue: "rich.system.envChanged")
        /// 系统语言改变通知 cn/en
        public static let langChanged = Notification.Name(rawValue: "rich.system.langChanged")
        /// 清理cookie成功
        public static let clearCookie = Notification.Name(rawValue: "rich.system.clearCookie")
        /// WebContainer Back
        public static let webViewBack = Notification.Name(rawValue: "rich.system.webViewBack")
        /// 接口状态403
        public static let status403 = Notification.Name(rawValue: "rich.system.403")
        /// 网络状态变化
        public static let networkChanged = Notification.Name(rawValue: "rich.system.networkChanged")
    }
    /// 用户先关通知
    struct User {
        /// 用户登录
        public static let login = Notification.Name(rawValue: "rich.user.login")
        /// 退出登录
        public static let logout = Notification.Name(rawValue: "rich.user.logout")
        /// token
        public static let tokenInvalid = Notification.Name(rawValue: "rich.user.tokenInvalid")
    }
    /// WebNative
    struct WebNative {
        /// richapp eg: webView(url, title)
        public static let richapp = Notification.Name(rawValue: "rich.webnative.richapp")
    }
    /// SDK跳APP内路由
    struct Router {
        /// SDK跳APP内路由
        public static let jump = Notification.Name(rawValue: "rich.router.jump")
    }
}
