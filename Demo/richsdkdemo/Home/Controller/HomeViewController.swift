//
//  HomeViewController.swift
//  richdemo
//
//  Created by Apple on 3/3/21.
//

import UIKit
import HandyJSON
import RICHSDK

class HomeViewController: BaseViewController {
    
    enum `Type`: Int {
        case system
        case custom
        case showLoading
        case rectLoading
        case showToast
        case showAlert
        case showConfirm
        case sendRequest
        case game
        func title() -> String {
            switch self {
            case .system:
                return "normal page"
            case .custom:
                return "custom page"
            case .showLoading:
                return "show loading"
            case .rectLoading:
                return "rect loading"
            case .showToast:
                return "show toast"
            case .showAlert:
                return "show alert"
            case .showConfirm:
                return "show confirm"
            case .sendRequest:
                return "send request"
            case .game:
                return "get gameInfo"
            }
        }
    }
    var type: Type = .system {
        didSet {
            button?.setTitle(type.title(), for: [])
        }
    }
    weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "com_tabBar_home".localized()
        
        let button = UIButton(text: type.title(), color: UIColor.white, size: 16)
        self.button = button
        button.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        button.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
        }

        let array = [1, 2, 3]
        XLog("array[safe: 5] not crash \(String(describing: array[safe: 5]))")
        
        let bundle = Bundle(for: Swift.type(of: self))
        XLog(bundle)
        if let bundle = Bundle(identifier: "RICHSDK.framework") {
            XLog(bundle)
            if let view = bundle.loadNibNamed("PopAlertView", owner: nil, options: nil)?.first as? PopAlertView {
                XLog(view)
            }
        }
    }
    
    @objc func clickAction() {
        switch type {
        case .system:
            let vc = UIViewController()
            vc.view.backgroundColor = .hex("#666666")
            vc.title = type.title()
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        case .custom:
            let vc = BaseViewController()
            vc.view.backgroundColor = .hex("#999999", 0.5)
            vc.title = type.title()
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        case .showLoading:
            ToastUtil.showLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                ToastUtil.hide()
            }
        case .rectLoading:
            let container = UIView(frame: CGRect(x: (UIDevice.width - 300) * 0.5, y: UIDevice.navBarHeight, width: 300, height: 160))
            container.backgroundColor = UIColor.green
            view.addSubview(container)
            ToastUtil.showLoading(in: container)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                ToastUtil.hide()
                container.removeFromSuperview()
            }
        case .showToast:
            ToastUtil.showMessage("我对你默默地竖起了🖕")
        case .showAlert:
            PopAlertView.showTipAlert(obj: PopAlertObj(title: "alert_title".localized(), subtitle: "子标题"))
        case .showConfirm:
            let obj = PopAlertObj(title: "alert_title".localized(), subtitle: "你今天过得好吗？") {
                XLog("very fine!")
            }
            PopAlertView.showConfirmAlert(obj: obj)
        case .sendRequest:
            ToastUtil.showLoading()
            Api.request(UserApi.login(name: "", pwd: ""), keyPath: "list") { (result: ApiModel<TempUserModel>) in
                ToastUtil.hide()
                if result.isSuccess {
                    XLog([result.data, result.object, result.array])
                } else {
                    ToastUtil.showMessage(result.msg)
                }
            }
        case .game:
            let params: [String: Any] = [
                "CompetitionID": -1,
                "IsEventMenu": "false",
                "IsFirstLoad": "true",
                "IsMobile": "true",
                "LiveCenterEventId": 0,
                "LiveCenterSportId": 1,
                "SportID": 1,
                "VersionH": 0,
                "oCompetitionId": 0,
                "oEventIds": 0,
                "oIsFirstLoad": "true",
                "oPageNo": 0,
                "oSortBy": 1,
                "reqUrl": "/m/zh-cn/sports/football/select-competition/default?sc=ABIBAH&theme=YB5"
            ]
            ToastUtil.showLoading()
            Api.request(HomeApi.gameInfo(params: params), keyPath: "lpd") { (result: ApiModel<GameInfoModel>) in
                ToastUtil.hide()
                if result.isSuccess {
                    XLog([result.data, result.object, result.array])
                } else {
                    ToastUtil.showMessage(result.msg)
                }
            }
        }
        
        if let type = Type(rawValue: type.rawValue + 1) {
            self.type = type
        } else {
            self.type = .system
        }
    }
    
}
