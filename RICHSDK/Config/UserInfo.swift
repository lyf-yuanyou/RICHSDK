//
//  UserInfo.swift
//  RICHSDK
//
//  Created by Apple on 1/4/21.
//

import Foundation

/// 用户信息
public class UserInfo {
    private var _isLogin: Bool
    private var _userId: String?
    private var _userName: String?
    private var _userToken: String?
    private var _imToken: String?
    private var _sabaToken: String?
    private var _balance: String? // 用户余额

    public var isLogin: Bool { return _isLogin }
    public var userId: String? { return _userId }
    public var userName: String? { return _userName }
    public var userToken: String? { return _userToken }
    public var imToken: String? { return _imToken }
    public var sabaToken: String? { return _sabaToken }
    public var balance: String? { return _balance }

    public static let shared = UserInfo()

    public static func update(isLogin: Bool? = nil,
                              userId: String? = nil,
                              userName: String? = nil,
                              userToken: String? = nil,
                              imToken: String? = nil,
                              sabaToken: String? = nil) {
        if let isLogin = isLogin {
            shared._isLogin = isLogin
        }
        if let userId = userId {
            shared._userId = userId
        }
        if let userName = userName {
            shared._userName = userName
        }
        if let userToken = userToken {
            shared._userToken = userToken
        }
        if let imToken = imToken {
            shared._imToken = imToken
        }
        if let sabaToken = sabaToken {
            shared._sabaToken = sabaToken
        }
    }

    private init() {
        _isLogin = false
    }

    public static func updateBalance(bal: String) {
        shared._balance = bal
    }
}
