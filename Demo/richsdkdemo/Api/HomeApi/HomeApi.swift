//
//  HomeApi.swift
//  richdemo
//
//  Created by Apple on 25/1/21.
//

import Foundation
import Alamofire
import RICHSDK

/// 首页相关接口
///
/// - gameInfo: 获取game信息
enum HomeApi: URLRequestConvertible {

    /// 获取game信息 
    case gameInfo(params: [String: Any])
    
    case home

    static var baseURLString: String { URLConfig.dlHost.url() }

    var method: Alamofire.HTTPMethod {
        switch self {
        default:
            return .post
        }
    }

    var path: String {
        switch self {
        case .gameInfo:
            return "zh-cn/Service/CentralService?GetData&ts=1614402480400"
        case .home:
            return "zh-cn/Service/CentralService?GetData&ts=1614402480400"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try (HomeApi.baseURLString + path).asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = URLConfig.dlHost.httpHeaders()

        switch self {
        case .gameInfo(let params):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        case .home:
            let params: Parameters = [
                "CompetitionID": -1,
                "reqUrl": "/m/zh-cn/sports/?sc=ABIAJJ&theme=YB5"
            ]
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }
        
//        URLConfig.game.httpHeaders().dictionary.forEach { urlRequest.setValue("\($0.value)", forHTTPHeaderField: $0.key) }

        return urlRequest
    }
}
