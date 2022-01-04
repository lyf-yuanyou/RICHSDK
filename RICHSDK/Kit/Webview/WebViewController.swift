//
//  WebViewController.swift
//  RICHSDK
//
//  Created by Apple on 27/4/21.
//

import FDFullscreenPopGesture
import UIKit
import WebKit

public enum WebViewButtonItem: Int {
    /// 全屏
    case fullScreen
    /// 转账
    case transfer
    /// 刷新
    case reload
}

fileprivate extension String {
    var tokenUrl: String {
        if self.contains("token=") {
            return self
        }
        return self + "\(self.contains("?") ? "&" : "?")plat=ios&token=\(UserInfo.shared.userToken ?? "")"
    }
}

open class WebViewController: BaseViewController {
    private var url: String?
    weak var webView: WKWebView!
    weak var progressView: WebViewProgressView!
    weak var halfBtn: UIButton!
    private var observeHandler: NSKeyValueObservation?
    public var buttonItems: [WebViewButtonItem] = []
    /// 场馆ID
    public var venueId: String?
    /// 底部安全区域
    open var useSafeArea: Bool {
        return false
    }

    public init(title: String?, url: String) {
        super.init(nibName: nil, bundle: nil)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIDevice.width - 108, height: 44))
        label.text = title
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = navBarStyle.color()
        label.sizeToFit()
        navigationItem.titleView = label
        self.url = url
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        fd_interactivePopDisabled = false
        setupUI()
        if let _ = venueId {
            showLoading()
        }
        // 监听登录
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: Notification.Name.User.login, object: nil)
    }

    @objc private func userLogin() {
        reload(force: true)
    }

    private func setupUI() {
        if let image = UIImage(named: "pic_bannerBG") {
            let bgImageView = UIImageView(image: image)
            view.addSubview(bgImageView)
            bgImageView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
            }
        } else {
            view.backgroundColor = .hex(0xFDAA22)
        }
        setupWebView()
        var rightBarButtonItems: [UIBarButtonItem] = []
        for (index, itemType) in buttonItems.enumerated() {
            let item: UIBarButtonItem
            switch itemType {
            case .fullScreen:
                item = UIBarButtonItem(image: UIImage(named: "full_screen", in: Localized.bundle, compatibleWith: nil),
                                       style: .plain,
                                       target: self,
                                       action: #selector(fullScreen))
            case .transfer:
                item = UIBarButtonItem(image: UIImage(named: "transfer", in: Localized.bundle, compatibleWith: nil),
                                       style: .plain,
                                       target: self,
                                       action: #selector(transfer))
            case .reload:
                item = UIBarButtonItem(image: UIImage(named: "refresh", in: Localized.bundle, compatibleWith: nil),
                                       style: .plain,
                                       target: self,
                                       action: #selector(reload))
            }
            item.tag = index
            rightBarButtonItems.append(item)
        }
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }

    private func setupWebView() {
        let userContentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = userContentController
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = .init(rawValue: 0)
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIDevice.width, height: view.height), configuration: config)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        if #available(iOS 11.0, *) {
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        view.addSubview(webView)
        self.webView = webView
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            if useSafeArea {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        let progressView = WebViewProgressView(frame: CGRect(x: 0, y: UIDevice.navBarHeight, width: UIDevice.width, height: 2))
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
        }
        let halfBtn = UIButton()
        halfBtn.setImage(UIImage(named: "exit_full_screen", in: Localized.bundle, compatibleWith: nil), for: .normal)
        halfBtn.isHidden = true
        halfBtn.imageEdgeInsets = .init(top: -12, left: 0, bottom: 0, right: 0)
        self.halfBtn = halfBtn
        halfBtn.addTarget(self, action: #selector(halfScreen(_:)), for: .touchUpInside)
        webView.addSubview(halfBtn)
        halfBtn.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        syncUserState()
        observeHandler = webView.observe(\.estimatedProgress, options: [.new, .old]) { [weak progressView, weak self] webView, change in
            if let oldValue = change.oldValue, let newValue = change.newValue {
                if oldValue > newValue { return }
                let progress = webView.estimatedProgress
                XLog(progress)
                progressView?.setProgress(Float(progress), animated: true)
                if progress > 0.75 {
                    self?.removeLoading()
                }
                if progress >= 1.0 {
                    self?.setWebTitle()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
        reload(force: true)
    }

    @objc func fullScreen() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        halfBtn.isHidden = false
    }

    @objc func halfScreen(_ button: UIButton) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        button.isHidden = true
    }

    @objc func transfer() {
        if let url = URL(string: WebNativeActionPolicy.richappWebScheme + "event?type=transfer&param0=" + (venueId ?? "")) {
            webView.load(URLRequest(url: url))
        }
    }

    @objc public func reload(force: Bool = false) {
        if force {
            if let urlString = self.url?.tokenUrl, let url = URL(string: urlString) {
                let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
                webView.load(request)
                XLog("load url:\(urlString)")
            } else {
                XLog("invalid url:\(self.url ?? "")")
            }
        } else {
            if webView.isLoading {
                webView.stopLoading()
            }
            webView.reload()
        }
    }

    private func syncUserState() {
        let cookie = """
            document.cookie='platform=iOS';
            document.cookie='version=%@';
            document.cookie='language=%@';
            document.cookie='userId=%@';
            document.cookie='token=%@';
        """
        let source = String(format: cookie, AppConfig.appVersion, Localized.language.rawValue,
                            UserInfo.shared.userId ?? "", UserInfo.shared.userToken ?? "")
        let userScript = WKUserScript(source: source, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webView.configuration.userContentController.addUserScript(userScript)
        if !webView.isLoading {
            webView.reload()
        }
    }

    override public func back() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        webView.configuration.userContentController.removeAllUserScripts()
        NotificationCenter.default.post(name: Notification.Name.System.webViewBack, object: nil)
        if navigationController?.viewControllers.count == 1 {
            dismiss(animated: true, completion: nil)
        } else {
            if UIDevice.current.orientation != .portrait {
                forceOrientation(.portrait)
            }
            super.back()
        }
    }

    func setWebTitle() {
        if let titleLabel = navigationItem.titleView as? UILabel, titleLabel.text?.isEmpty ?? true {
            let script = "document.getElementsByClassName('van-nav-bar__title')[0].innerText"
            webView.evaluateJavaScript(script) { [weak webView] webTitle, error in
                if error == nil, let title = webTitle as? String {
                    titleLabel.text = title
                    titleLabel.sizeToFit()
                } else if let title = webView?.title {
                    titleLabel.text = title
                    titleLabel.sizeToFit()
                }
            }
        }
    }

    deinit {
        XLog("WebViewController dealloc")
    }
}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setWebTitle()
    }
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        XLog(error.localizedDescription)
    }
    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url?.absoluteString ?? ""
        decisionHandler(WebNativeActionPolicy.actionPolicy(host: url.trim()) ? .cancel : .allow)
    }
    open func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse,
                      decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension WebViewController {
    func showLoading() {
        if let image = UIImage(named: "venue_loading", in: Localized.bundle, compatibleWith: nil) {
            let icon = UIImageView(image: image)
            icon.tag = 100
            webView.addSubview(icon)
            icon.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    func removeLoading() {
        if let icon = webView.viewWithTag(100) as? UIImageView {
            UIView.animate(withDuration: 0.25) {
                icon.alpha = 0
            } completion: { _ in
                icon.removeFromSuperview()
            }
        }
    }
}

extension WebViewController {
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight, .portrait]
    }
}
