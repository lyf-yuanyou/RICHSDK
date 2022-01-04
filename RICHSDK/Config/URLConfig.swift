//
//  URLConfig.swift
//  richdemo
//
//  Created by Apple on 25/1/21.
//
import Alamofire
import Foundation

/// URL Host 项目请求地址配置
///
/// - user: user api 全站项目
/// - dlHost: 静态文件download json url
public enum URLConfig {
    /// user api 站项目
    case user
    /// 静态文件download json url
    case dlHost
    /// 云雀接口
    case yqHost

    public static var webHosts: [String] {
        if AppConfig.state == .release {
            return [
                "api.afafay.xyz",
                "api.afafaystar.xyz",
                "api.myfaow.xyz",
                "api.wefaow.xyz",
                "api.yafds.xyz"
            ]
        }
        return [curUserHost]
    }
    public static var dlHosts: [String] {
        if AppConfig.state == .release {
            return [
                "dl.afafay.xyz",
                "dl.afafaystar.xyz",
                "dl.myfaow.xyz",
                "dl.wefaow.xyz",
                "dl.yafds.xyz"
            ]
        }
        return [curDlHost]
    }
    public static var yqHosts: [String] {
        if AppConfig.state == .release {
            return [
                "yq.richvn10.com"
            ]
        }
        return [curYqHost]
    }

    public static var doMainHosts: [String] {
        if AppConfig.state == .release {
            return [
                "https://dl.ymenet.xyz/app/json/domain.json",
                "https://dl.afafay.xyz/app/json/domain.json",
                "https://dl.afafaystar.xyz/app/json/domain.json",
                "https://dl.myfaow.xyz/app/json/domain.json",
                "https://dl.wefaow.xyz/app/json/domain.json",
                "https://dl.yafds.xyz/app/json/domain.json"
            ]
        }
        return []
    }

    static var curDlHost: String {
        switch AppConfig.state {
        case .debug:
            return "dl.yostata.xyz"
        case .release:
            return "dl.afafay.xyz"
        case .uat:
            return "dl.xecloln.xyz"
        }
    }
    static var curUserHost: String {
        switch AppConfig.state {
        case .debug:
            return "h5.yostata.xyz"
        case .release:
            return "api.afafay.xyz"
        case .uat:
            return "api.xecloln.xyz"
        }
    }
    static var curYqHost: String {
        switch AppConfig.state {
        case .debug:
            return "iosqianm.ystata.xyz"
        default:
            return "yq.richkvn10.com"
        }
    }

    static let curDlHostKey: String = "curDlHostKey"
    static let curUserHostKey: String = "curUserHostKey"
    static let curYqHostKey: String = "curYqHostKey"

    // 定义变量，防止setWebFastHost重复请求
    private static var webDomainRequesting = false

    public static func setWebFastHost(hosts: [String], netHosts: [String]) {
        guard !webDomainRequesting else { return }
        webDomainRequesting = true

        XLog("完成domain")
        // 先移除本地key
        UserDefaults.standard.removeObject(forKey: curUserHostKey)
        UserDefaults.standard.synchronize()

        var totalHosts = hosts
        if !netHosts.isEmpty {
            totalHosts = netHosts
        }

        var requestCount = totalHosts.count
        totalHosts.forEach({
            let host = $0
            AF.request("\(hostHead)\($0)/member/version").response { data in
                if data.response?.statusCode == 200 {
                    let url = UserDefaults.standard.string(forKey: curUserHostKey)
                    if url == nil || url!.isEmpty {
                        XLog("保存webHost:\(host)")
                        UserDefaults.standard.setValue(host, forKey: curUserHostKey)
                        URLConfig.localWebUrl = host
                    }
                }
                // 全部请求完成后，将webDomainRequesting置为false
                requestCount -= 1
                if requestCount == 0 { webDomainRequesting = false }
            }
        })
    }

    // 定义变量，防止setDlFastHost重复请求
    private static var dlDomainRequesting = false

    public static func setDlFastHost(hosts: [String], netHosts: [String]) {
        guard !dlDomainRequesting else { return }
        dlDomainRequesting = true

        // 先移除本地key
        UserDefaults.standard.removeObject(forKey: curUserHostKey)
        UserDefaults.standard.synchronize()

        var totalHosts = hosts
        if !netHosts.isEmpty {
            totalHosts = netHosts
        }

        var requestCount = totalHosts.count
        totalHosts.forEach({
            let host = $0
            AF.request("\(hostHead)\($0)/app/json/domain.json").response { _ in
                let url = UserDefaults.standard.string(forKey: curDlHostKey)
                if url == nil || url!.isEmpty {
                    XLog("保存dlHost:\(host)")
                    UserDefaults.standard.setValue(host, forKey: curDlHostKey)
                    URLConfig.localdlUrl = host
                }
                // 全部请求完成后，将webDomainRequesting置为false
                requestCount -= 1
                if requestCount == 0 { dlDomainRequesting = false }
            }
        })
    }

    // 定义变量，防止setYQFastHost重复请求
    private static var yqDomainRequesting = false
    public static func setYQFastHost(hosts: [String], netHosts: [String]) {
        guard !yqDomainRequesting else { return }
        yqDomainRequesting = true

        // 先移除本地key
        UserDefaults.standard.removeObject(forKey: curYqHostKey)
        UserDefaults.standard.synchronize()

        var totalHosts = hosts
        if !netHosts.isEmpty {
            totalHosts = netHosts
        }

        var requestCount = totalHosts.count
        totalHosts.forEach({
            let host = $0
            AF.request("\("https://")\($0)").response { _ in
                let url = UserDefaults.standard.string(forKey: curYqHostKey)
                if url == nil || url!.isEmpty {
                    XLog("保存YqHost:\(host)")
                    UserDefaults.standard.setValue(host, forKey: curYqHostKey)
                    URLConfig.localyqUrl = host
                }
                // 全部请求完成后，将webDomainRequesting置为false
                requestCount -= 1
                if requestCount == 0 { yqDomainRequesting = false }
            }
        })
    }

    private static var hostHead: String {
        AppConfig.state == .release ? "https://" : "http://"
    }

    public static func updateFastHost() {
        // 测试环境没有domain.json，固定host
        if AppConfig.state != .release {
            return
        }

        // 清空本地保存的host
        clearFastHost()

        let list: [String] = doMainHosts
        // 用来存储可用的domain host
        var domainHost: String = ""
        // 用来存储从服务器获取的域名数组
        // 接口
        var netWebHosts: [String] = []
        // 下载
        var netDlHosts: [String] = []
        // 云雀
        var netYQHosts: [String] = []

        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "request_domain_queue")

        group.enter()
        serialQueue.async {
            XLog("1、先获取可用domian host")
            let sema = DispatchSemaphore(value: 0)
            if !list.isEmpty {
                list.forEach({
                    let host = $0
                    AF.request($0).response { result in
                        if result.response?.statusCode == 200 {
                            XLog("可用的domain是：\(host)")
                            domainHost = host
                            sema.signal()
                            return
                        }
                    }
                })
            } else {
                sema.signal()
            }
            sema.wait()
            group.leave()
        }

        group.enter()
        serialQueue.async {
            XLog("2、根据domainhost 获取可用域名")
            let sema = DispatchSemaphore(value: 0)
            AF.request(!domainHost.isEmpty ? domainHost : "\(hostHead)\(curDlHost)/app/json/domain.json").responseJSON { response in
                sema.signal()
                switch response.result {
                case .success(let value):
                    if let value = value as? [String: Any] {
                        if let arr = value["dl"] as? [String], !arr.isEmpty {
                            let list = arr.map { apiValue -> String in
                                // 去掉头
                                if apiValue.contains("://"), let shothost = URL(string: apiValue)?.host {
                                    return shothost
                                } else {
                                    return apiValue
                                }
                            }
                            netDlHosts.append(contentsOf: list)
                        }

                        if let arr = value["api"] as? [String], !arr.isEmpty {
                            let list = arr.map { apiValue -> String in
                                // 去掉头
                                if apiValue.contains("://"), let shothost = URL(string: apiValue)?.host {
                                    return shothost
                                } else {
                                    return apiValue
                                }
                            }
                            netWebHosts.append(contentsOf: list)
                        }

                        if let arr = value["yq"] as? [String], !arr.isEmpty {
                            let list = arr.map { apiValue -> String in
                                // 去掉头
                                if apiValue.contains("://"), let shothost = URL(string: apiValue)?.host {
                                    return shothost
                                } else {
                                    return apiValue
                                }
                            }
                            netYQHosts.append(contentsOf: list)
                        }
                    }
                default : break
                }
            }
            sema.wait()
            group.leave()
        }

        group.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async {
                XLog("完成dl domain")
                // 请求获取最快的host
                URLConfig.setWebFastHost(hosts: URLConfig.webHosts, netHosts: netWebHosts)
                URLConfig.setDlFastHost(hosts: URLConfig.dlHosts, netHosts: netDlHosts)
                URLConfig.setYQFastHost(hosts: URLConfig.yqHosts, netHosts: netYQHosts)
            }
        }
    }

    static func clearFastHost() {
        UserDefaults.standard.removeObject(forKey: curDlHostKey)
        UserDefaults.standard.removeObject(forKey: curUserHostKey)
        UserDefaults.standard.removeObject(forKey: curYqHostKey)
        UserDefaults.standard.synchronize()
    }

    private static var localWebUrl: String?
    private static var localdlUrl: String?
    private static var localyqUrl: String?
    /// 获取URL
    public func url() -> String {
        switch self {
        case .user:
            // debug/uat环境直接取地址
            if AppConfig.state != .release {
                return URLConfig.hostHead + URLConfig.curUserHost + "/"
            }
            if URLConfig.localWebUrl == nil {
                URLConfig.localWebUrl = UserDefaults.standard.value(forKey: URLConfig.curUserHostKey) as? String
            }
            // 如果本地保存了最快的域名，则使用最快的， 如果没有保存最快的域名，则使用默认域名，并且获取最快的域名
            if let localWebURL = URLConfig.localWebUrl, !localWebURL.isEmpty {
                return URLConfig.hostHead + localWebURL + "/"
            } else {
                return URLConfig.hostHead + URLConfig.curUserHost + "/"
            }
        case .dlHost:
            if AppConfig.state != .release {
                return URLConfig.hostHead + URLConfig.curDlHost + "/"
            }
            if URLConfig.localdlUrl == nil {
                URLConfig.localdlUrl = UserDefaults.standard.value(forKey: URLConfig.curDlHostKey) as? String
            }
            // 如果本地保存了最快的域名，则使用最快的， 如果没有保存最快的域名，则使用默认域名，并且获取最快的域名
            if let localdlUrl = URLConfig.localdlUrl, !localdlUrl.isEmpty {
                return URLConfig.hostHead + localdlUrl + "/"
            } else {
                return URLConfig.hostHead + URLConfig.curDlHost + "/"
            }
        case .yqHost:
            if AppConfig.state != .release {
                return "https://" + URLConfig.curYqHost + "/"
            }
            if URLConfig.localyqUrl == nil {
                URLConfig.localyqUrl = UserDefaults.standard.value(forKey: URLConfig.curYqHostKey) as? String
            }
            // 如果本地保存了最快的域名，则使用最快的， 如果没有保存最快的域名，则使用默认域名，并且获取最快的域名
            if let localdlUrl = URLConfig.localyqUrl, !localdlUrl.isEmpty {
                return "https://" + localdlUrl + "/"
            } else {
                return "https://" + URLConfig.curYqHost + "/"
            }
        }
    }
    /// 获取该域名下请求头
    public func httpHeaders() -> HTTPHeaders {
        switch self {
        case .user:
//            let headers: [String: String] = [
//                "Accept": "*/*",
//                "Accept-Encoding": "gzip, deflate, br",
//                "Accept-Language": "zh-CN,zh;q=0.9,en;q=0.8",
//                "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8",
//                "Cookie": "ASP.NET_SessionId=42cz254rneerd2mwc2eoiaqf; sbmwl3-yb4=1829900042.20480.0000; redirect=done; lobbyUrl=localhost; logoutUrl=localhost; settingProfile=OddsType=1&NoOfLinePerEvent=1&SortBy=1&AutoRefreshBetslip=True; fav3=; favByBetType=; fav-com=; CCDefaultTvPlay=; CCDefaultBgPlay=; timeZone=480; opCode=YB5; mc=; BS@Cookies=; historyUrl=%2Fm%2Fzh-cn%2Fsports%2Fboxing%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fhandball%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fdarts%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fice-hockey%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fspecials%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fgolf%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fcricket%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Ffinancial-bets%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fbasketball%2Fselect-competition%2Fdefault%3Fsc%3DABIBAJ%26theme%3DYB5%7C%2Fm%2Fzh-cn%2Fsports%2Fbasketball%2Fcompetition%2Ffull-time-asian-handicap-and-over-under%3Fsc%3DABIBAJ%26competitionids%3D27096%26theme%3DYB5",
//                "Origin": "https://xj-mbs-yb5.2r9qgy.com",
//                "Referer": "https://xj-mbs-yb5.2r9qgy.com/m/zh-cn/sports/?sc=ABIAJJ&theme=YB5",
//                "sec-fetch-dest": "empty",
//                "sec-fetch-mode": "cors",
//                "sec-fetch-site": "same-origin"
//            ]
            return HTTPHeaders(["d": "3"]) // 1:WEB 2:H5 3:iOS 4:Android
        default:
            return HTTPHeaders()
        }
    }
}
