//
//  RouterProtocol.swift
//  RICHSDK
//
//  Created by Apple on 18/6/21.
//

import UIKit

/// 在上层SDK里面跳转App里面的页面
public class SDKRouter {
    /// 在上层SDK里面跳转App里面的页面
    ///
    /// - Parameter type: 跳转类型
    /// - Parameter paramsList: 参数列表，需要按照顺序排列
    public static func jump(type: String, paramsList: [String]? = nil) {
        var routeString = type
        if let paramsList = paramsList, !paramsList.isEmpty {
            routeString = String(format: "%@(%@)", routeString,
                                 paramsList.compactMap({ $0.replacing(regex: ",", with: "%2c") }).joined(separator: ","))
        }
        NotificationCenter.default.post(name: Notification.Name.Router.jump, object: routeString, userInfo: ["string": routeString])
    }
}
