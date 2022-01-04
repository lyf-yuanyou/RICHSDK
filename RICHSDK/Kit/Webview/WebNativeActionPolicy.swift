//
//  WebNativeActionPolicy.swift
//  RICHSDK
//
//  Created by Apple on 27/4/21.
//

import Foundation

class WebNativeActionPolicy {
    static let richappScheme = "richapp://"
    static let richappWebScheme = Localized.language == .vietnam ? "yiyappnative://" : "richsdknative://"
    static let ParamsKeyArray = ["param0", "param1", "param2", "param3", "param4", "param5", "param6", "param7", "param8", "param9"]

    /// h5跳转事件拦截
    ///
    /// - Parameter host: URL
    /// - Returns: true：表示事件被拦截，不用再处理
    class func actionPolicy(host: String) -> Bool {
        /**
         协议：superbuynative://event?type=xxx&WtagA=xxx&WtagQ=xxx&Ntag=xxx&param0=xxx&param1=xxx...
         如跳转包裹支付协议为：superbuynative://event?type=pay&param0=invoiceId&param1=0
         */
        var range: Range<String.Index>?
        var notificationName: Notification.Name?
        if let value = host.range(of: richappWebScheme) {
            range = value
            notificationName = Notification.Name.WebNative.richapp
        }
        if let range = range, let notificationName = notificationName {
            // 获取参数
            let params = String(host.suffix(from: range.upperBound)).trim().getURLParams()
            let valueArray = ParamsKeyArray.compactMap({ params[$0] }).compactMap({ $0.removingPercentEncoding })
            // 获取事件类型
            if let type = params["type"], !type.isEmpty {
                let routeString = String(format: "%@(%@)", type,
                                         valueArray.compactMap({ $0.replacing(regex: ",", with: "%2c") }).joined(separator: ","))
                NotificationCenter.default.post(name: notificationName, object: routeString, userInfo: ["string": routeString])
                return true
            }
        }

        return false
    }
}
