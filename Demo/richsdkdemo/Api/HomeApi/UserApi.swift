//
//  UserApi.swift
//  richdemo
//
//  Created by Apple on 25/1/21.
//

import Alamofire
import Foundation
import RICHSDK

/// 用户相关接口
///
/// - login: 登录
/// - verifyCode: 获取短信验证码
/// - updateUserInfo: 更新用户信息
public enum UserApi: URLRequestConvertible {
    /// 登录
    case login(name: String, pwd: String)
    /// 获取短信验证码
    case verifyCode
    /// 更新用户信息
    case register(params: Parameters)

    public static var baseURLString: String { URLConfig.user.url() }

    public var method: Alamofire.HTTPMethod {
        switch self {
        case .verifyCode:
            return .get
        default:
            return .post
        }
    }

    public var path: String {
        switch self {
        case .login:
            return "member/login"
        case .verifyCode:
            return "member/captcha"
        case .register:
            return "member/reg"
        }
    }

    public func asURLRequest() throws -> URLRequest {
        let url = try UserApi.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = URLConfig.user.httpHeaders()

        switch self {
        case let .login(name, pwd):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: ["name": name, "password": pwd])
        case let .register(params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
            break
        }

//        URLConfig.user.httpHeaders().forEach { urlRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }

        return urlRequest
    }
}
