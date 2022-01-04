//
//  Api.swift
//  richdemo
//
//  Created by Apple on 25/1/21.
//

import Alamofire
import CommonCrypto
import CoreTelephony
import Foundation
import HandyJSON

/// 通过泛型转模型统一输出，兼容多版本API
public class ApiModel<T: HandyJSON>: HandyJSON {
    /// 状态码
    public var code: Int = 0

    /// 错误信息
    public var msg: String = ""

    /// 返回原始数据
    public var data: Any?

    /// 返回转模型后的对象
    public var object: T?

    /// 返回转模型后的对象数组
    public var array: [T]?

    private var status: Bool?

    /// 返回数据是否来自缓存
    public var isCached = false

    /// response header
    public var headers = HTTPHeaders()

    /// 是否成功请求到数据
    public var isSuccess: Bool { return self.code == Api.kSuccess }

    public required init() { }

    public func mapping(mapper: HelpingMapper) {
        mapper <<<
            status <-- "status"
        mapper <<<
            code <-- "code"
        mapper <<<
            msg <-- "msg"
        mapper <<<
            data <-- "data"
    }

    public func didFinishMapping() {
        if let status = status {
            code = status ? 0 : -1
            if !status {
                msg = "\(data ?? "")"
            }
        }
    }

    init(error: Api.Error) {
        code = error.rawValue
        switch error {
        case .noNetwork:
            msg = "error_network".sdkLocalized()
        case .timeout:
            msg = "error_request_timeout".sdkLocalized()
        default:
            msg = "error_server_error".sdkLocalized()
        }
    }
}

private var urlKeyHandle: UInt8 = 0 << 4

/// Api接口层，提供不同的接口服务
public class Api {
    /// 请求失败错误类型
    ///
    /// - noNetwork: 无网络
    /// - timeout: 请求超时
    /// - dataError: 解析数据失败
    /// - serverError: 服务器错误，responseCode != 200
    enum Error: Int {
        case noNetwork = -1
        case timeout = -2
        case dataError = -3
        case serverError = -4
    }

    /// 请求时是否显示loading
    ///
    /// - none: 不显示（默认选项）
    /// - selfView: 显示在当前控制器view上，loading不会全屏覆盖（推荐）
    /// - keyWindow: 顶级window上，如果请求事件过长用户无法操作（不建议）
    /// - some(View): 在指定的view中显示loading
    public enum Loading<View> {
        /// 不显示（默认选项）
        case none
        /// 显示在当前控制器view上，loading不会全屏覆盖（推荐）
        case selfView
        /// 顶级window上，如果请求事件过长用户无法操作（不建议）
        case keyWindow
        /// 在指定的view中显示loading
        case some(View)
    }

    /// response data缓存策略
    ///
    /// - none: 不缓存（默认选项）
    /// - urlasKey: url作为key
    /// - key(String): 在指定的view中显示loading
    public enum Cache<String> {
        /// 不显示（默认选项）
        case none
        /// 不显示（默认选项）
        case urlasKey
        /// 在指定的view中显示loading
        case key(String)
    }

    /// 接口成功码
    public static let kSuccess: Int = 0
    public static let apiVersion = "1.0.0"
    /// 这些接口失败(非200)后需要更新host
    /// - richapp: ["member/login", "member/reg", "game/launch", "member/platform", "finance/cate"]
    public static var filterApiList: [String]?

    static let acceptableContentTypes = ["application/json", "text/json", "text/plain"] // text/plain用来支持Charles Local Map

    private static let serializationQueue = DispatchQueue(label: "rich.session.serializationQueue", qos: .default, attributes: .concurrent)

    static let `default`: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.HTTPHeaders.default.dictionary
        configuration.timeoutIntervalForRequest = 25
        var serverTrustPolicies: [String: ServerTrustEvaluating] = [:]
        /**
         SSL安全认证：与服务器建立安全连接需要对服务器进行验证，可以用证书或者公钥私钥来实现
         该网络框架支持的证书类型：[".cer", ".CER", ".crt", ".CRT", ".der", ".DER"]
         1、DefaultTrustEvaluator 默认策略
         2、SSL Pinning阻止中间人Charles攻击
            - PinnedCertificatesTrustEvaluator 内置证书，将证书放入app的bundle里
            - PublicKeysTrustEvaluator 内置公钥，将证书的公钥硬编码进代码里
         3、DisabledEvaluator 不验证
         然并卵 - 我们公司的网络连接并没有SSL安全认证，强烈吐槽
         */
        // TODO:认证不通过，暂时去掉
//        ["api.xxx.com"].compactMap{ HttpDnsService.sharedInstance()?.getIpByHostAsync($0) }.forEach{ serverTrustPolicies[$0] = DisabledEvaluator() }
//        return Alamofire.Session(configuration: configuration, serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicies))
        let requestQueue = DispatchQueue(label: "rich.session.requestQueue", qos: .default, attributes: .concurrent)
        return Alamofire.Session(configuration: configuration,
                                 requestQueue: requestQueue,
                                 serializationQueue: serializationQueue)
    }()

    /// 带模型转换的网络请求，模型是对象Object
    ///
    /// - Parameters:
    ///   - urlRequest: 自定义请求对象
    /// - Returns: DataRequest，无网络时不执行请求返回nil
    @discardableResult
    public class func request(_ urlRequest: URLRequestConvertible) -> DataRequest? {
        if let isReachable = NetworkReachabilityManager()?.isReachable, !isReachable {
            if let keyWindow = UIApplication.shared.keyWindow {
                ToastUtil.showMessage("error_network".sdkLocalized(), inView: keyWindow)
            }
            return nil
        }
        return Api.default.request(urlRequest).validate(statusCode: [200])
    }

    /// 带模型转换的网络请求，模型是对象Object
    ///
    /// - Parameters:
    ///   - urlRequest: 自定义请求对象
    ///   - keyPath: 对象路径keyPath，是从data后面key开始算起的
    ///   - loading: 是否显示loading
    ///   - cached: 是否缓存数据
    ///   - completionHandler: 完成回调
    /// - Returns: DataRequest，无网络时不执行请求返回nil
    @discardableResult
    public class func request<T: HandyJSON>(_ urlRequest: URLRequestConvertible,
                                            keyPath: String? = nil,
                                            loading: Loading<UIView> = .none,
                                            cached: Cache<String> = .none,
                                            completionHandler: @escaping(_ result: ApiModel<T>) -> Void) -> DataRequest? {
        // 1、无论是否有网络，如果设置了缓存，先从缓存获取数据
        var urlString: String?
        var key: String?
        if case .key(let string) = cached {
            key = string
        } else if case .urlasKey = cached {
            key = urlRequest.urlRequest?.url?.absoluteString
            urlString = key
        }
        if let key = key, !key.isEmpty, let value = Storage.getJson(key: key.md5()),
           let result = ApiModel<T>.deserialize(from: wrapper(value: value)) {
            result.object = T.deserialize(from: result.data as? [String: Any], designatedPath: keyPath)
            if result.object == nil, let jsonObj = result.data,
               let data = try? JSONSerialization.data(withJSONObject: jsonObj, options: .fragmentsAllowed),
               let string = String(data: data, encoding: .utf8) {
                result.array = [T].deserialize(from: string, designatedPath: keyPath)?.compactMap({ $0 })
            }
            result.isCached = true
            completionHandler(result)
        }
        // 2、检查网络是否连接，未连接直接返回错误并提示
        if let isReachable = NetworkReachabilityManager.default?.isReachable, !isReachable {
            completionHandler(ApiModel(error: .noNetwork))
            DispatchQueue.main.async { NetErrorView.show() }
            return nil
        }
        // 3、如果设置了loading，显示loading
        var loadingView: UIView?
        DispatchQueue.main.async {
            switch loading {
            case .keyWindow:
                loadingView = UIApplication.shared.keyWindow
            case .selfView:
                loadingView = UIApplication.topViewController?.view
            case .some(let view):
                loadingView = view
            default:
                break
            }
            if let loadingView = loadingView {
                if var url = urlString ?? urlRequest.urlRequest?.url?.absoluteString {
                    if let index = url.firstIndex(of: "?") {
                        url = String(url.prefix(upTo: index))
                    }
                    objc_setAssociatedObject(loadingView, &urlKeyHandle, url, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
                ToastUtil.showLoading(in: loadingView)
            }
        }
        // 4、开始请求数据
        return Api.default.request(urlRequest).validate(statusCode: [200]).validate(contentType: acceptableContentTypes)
            .responseJSON(queue: serializationQueue) { response in
            switch response.result {
            case .success(let value):
                XLog("😂😂\(String(describing: response.metrics)) \(String(describing: urlRequest)) \(value) 🚀end")
                var result = ApiModel<T>(error: .dataError)
                if let value = value as? [String: Any] {
                    if let model = ApiModel<T>.deserialize(from: wrapper(value: value)) {
                        model.object = T.deserialize(from: model.data as? [String: Any], designatedPath: keyPath)
                        if model.object == nil, let jsonObj = model.data,
                           let data = try? JSONSerialization.data(withJSONObject: jsonObj, options: .fragmentsAllowed),
                           let string = String(data: data, encoding: .utf8) {
                            model.array = [T].deserialize(from: string, designatedPath: keyPath)?.compactMap({ $0 })
                        }
                        result = model
                    }
                    if let headers = response.response?.headers {
                        result.headers = headers
                    }
                    DispatchQueue.main.async {
                        completionHandler(result)
                        if !result.isSuccess, let data = result.data as? String, ["Token quá hạn", "token"].contains(data) {
                            UserInfo.update(isLogin: false, userToken: nil, imToken: nil)
                            UserDefaults.standard.setValue(nil, forKey: UserDefaultsKey.richUserToken)
                            UserDefaults.standard.synchronize()
                            NotificationCenter.default.post(name: Notification.Name.User.tokenInvalid, object: nil)
                        }
                    }
                    var key: String?
                    if case .key(let string) = cached {
                        key = string
                    } else if case .urlasKey = cached {
                        key = response.request?.url?.absoluteString
                        urlString = key
                    }
                    if let key = key, !key.isEmpty {
                        Storage.set(value.toJSONString(), for: key.md5())
                    }
                } else {
                    if let value = value as? [Any] {
                        let wrapperValue: [String: Any] = ["code": 0, "msg": "success", "data": value]
                        if let model = ApiModel<T>.deserialize(from: wrapperValue) {
                            model.object = T.deserialize(from: model.data as? [String: Any], designatedPath: keyPath)
                            if model.object == nil, let jsonObj = model.data,
                               let data = try? JSONSerialization.data(withJSONObject: jsonObj, options: .fragmentsAllowed),
                               let string = String(data: data, encoding: .utf8) {
                                model.array = [T].deserialize(from: string, designatedPath: keyPath)?.compactMap({ $0 })
                            }
                            result = model
                        }
                        if let headers = response.response?.headers {
                            result.headers = headers
                        }
                        DispatchQueue.main.async { completionHandler(result) }
                    }
                }
            case .failure(let error):
                XLog("😞😞\(String(describing: response.metrics)) \(String(describing: urlRequest)) \(error.localizedDescription) 🚀end")
                let result = ApiModel<T>(error: (error as NSError).code == NSURLErrorTimedOut ? .timeout : .serverError)
                if let headers = response.response?.headers {
                    result.headers = headers
                }
                DispatchQueue.main.async { completionHandler(result) }
                if let list = filterApiList, let url = response.request?.url?.absoluteString, list.contains(where: { url.contains($0) }) {
                    URLConfig.updateFastHost()
                }
            }
            DispatchQueue.main.async {
                if let loadingView = loadingView, let url = objc_getAssociatedObject(loadingView, &urlKeyHandle) as? String,
                   let originUrl = response.request?.url?.absoluteString, originUrl.hasPrefix(url) {
                    ToastUtil.hide(in: loadingView)
                }
            }
            }
    }

    private static func wrapper(value: [String: Any]) -> [String: Any] {
        var wrapperValue: [String: Any] = ["code": 0, "msg": "success", "data": value]
        if value.keys.contains("data") { // 普通数据
            wrapperValue = value
        } else if value.keys.contains("StatusCode") && value.keys.contains("StatusDesc") { // IM Sports
            let statusCode = value["StatusCode"] as? Int ?? 0
            let statusDesc = value["StatusDesc"] as? String ?? "success"
            wrapperValue["code"] = statusCode == 100 ? 0 : statusCode
            wrapperValue["msg"] = statusDesc
        } else if value.keys.contains("error_code") && value.keys.contains("Data") { // saba Sports
            wrapperValue = [
                "code": value["error_code"] as? Int ?? 0,
                "msg": value["message"] as? String ?? "success",
                "data": value["Data"]!
            ]
        }
        return wrapperValue
    }

    /// 是否设置了代理
    /// - Parameters:
    ///   - url: 请求地址 https://www.apple.com
    /// - Returns: 代理设置情况
    public static func isProxy(url: String) -> Bool {
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue(),
            let url = URL(string: url) else {
            return false
        }
        let proxies = CFNetworkCopyProxiesForURL((url as CFURL), proxySettings).takeUnretainedValue() as NSArray
        guard let settings = proxies.firstObject as? NSDictionary,
            let proxyType = settings.object(forKey: (kCFProxyTypeKey as String)) as? String else {
            return false
        }
        #if DEBUG
        if let hostName = settings.object(forKey: (kCFProxyHostNameKey as String)),
            let port = settings.object(forKey: (kCFProxyPortNumberKey as String)),
            let type = settings.object(forKey: (kCFProxyTypeKey)) {
            print("""
                host = \(hostName)
                port = \(port)
                type= \(type)
            """)
        }
        #endif
        return proxyType != (kCFProxyTypeNone as String)
    }
}

public class NetworkListener {
    /// 监听网络状态
    public static func start(_ showStatusBar: Bool = false) {
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { status in
            DispatchQueue.main.async {
                if showStatusBar {
                    switch status {
                    case .notReachable:
                        msgBar.backgroundColor = .hex(0xDC505A)
                        msgBar.show("error_network_proxy_no".sdkLocalized())
                    case .reachable(let type):
                        msgBar.backgroundColor = .hex(0x55F064)
                        let msg = "error_network_proxy_environment".sdkLocalized() +
                            (type == .cellular ? "error_network_proxy_cellier" : "error_network_proxy_wifi").sdkLocalized()
                        msgBar.show(msg)
                    default:
                        break
                    }
                }
                switch status {
                case .notReachable:
                    NetErrorView.show()
                case .reachable(let type):
                    XLog("网络状态：\(type)")
                    UIApplication.shared.keyWindow?.subviews.forEach({ view in
                        if view is MaskView, let errorView = view.subviews.first as? NetErrorView {
                            errorView.closeAction()
                        }
                    })
                default:
                    break
                }
                NotificationCenter.default.post(name: Notification.Name.System.networkChanged, object: status, userInfo: ["status": status])
            }
        })
    }

    private static var _msgBar: MsgBar!
    static var msgBar: MsgBar {
        if let msgBar = _msgBar {
            return msgBar
        }
        _msgBar = MsgBar(frame: CGRect(x: 0, y: 0, width: UIDevice.width, height: UIDevice.statusBarHeight))
        return _msgBar
    }

    class MsgBar: UIView {
        weak var textLabel: UILabel!
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .hex(0xDC505A)
            let label = UILabel(text: "", color: .white, size: 13)
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: self.height - 20, width: UIDevice.width, height: 20)
            textLabel = label
            addSubview(label)
        }

        func show(_ msg: String) {
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            keyWindow.subviews.filter({ $0 is MsgBar }).forEach({ $0.removeFromSuperview() })
            textLabel.text = msg
            keyWindow.addSubview(self)
            keyWindow.windowLevel = .alert
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                keyWindow.subviews.filter({ $0 is MsgBar }).forEach({ $0.removeFromSuperview() })
                UIApplication.shared.keyWindow?.windowLevel = .normal
            }
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

class NetErrorView: UIView {
    private static let netErrorView = NetErrorView()
    static func show() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        netErrorView.superview?.removeFromSuperview()
        netErrorView.removeFromSuperview()
        netErrorView.showPop(inView: keyWindow, widthFactor: 0.8, tapMaskClose: false)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 8
        let imageView = UIImageView(image: UIImage(named: "no_network", in: Localized.bundle, compatibleWith: nil))
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.width.equalTo(57)
            make.height.equalTo(44)
            make.top.equalTo(32)
            make.centerX.equalToSuperview()
        }
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "network_close", in: Localized.bundle, compatibleWith: nil), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.right.equalToSuperview()
        }
        let label = UILabel(text: "error_network_proxy_no".sdkLocalized(), color: .hex(0x6C6C6C), size: 14)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-20).priority(.low)
        }
    }

    @objc func closeAction() {
        closePop()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
