//
//  MyViewController.swift
//  richsdkdemo
//
//  Created by admin on 2021/3/16.
//

import UIKit
import RICHSDK

class MyViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        XLog("ssss = \(URLConfig.dlHost.url())")
        let lbl1 = creatyLbl(y: 200, font: .font(custom: .pingFangSCLight))
        view.addSubview(lbl1)
        let lbl2 = creatyLbl(y: 250, font: .font(custom: .pingFangSCThin, 15))
        view.addSubview(lbl2)
        let lbl3 = creatyLbl(y: 300, font: .font(custom: .pingFangSCSemibold, 20))
        view.addSubview(lbl3)
        let lbl4 = creatyLbl(y: 350, font: .font(custom: .pingFangSCUltralight))
        view.addSubview(lbl4)
        let lbl5 = creatyLbl(y: 400, font: .font(custom: .helveticaNeueMedium))
        view.addSubview(lbl5)
        
        let _ = UIButton().then {
            view.addSubview($0)
            $0.setTitle("Button", for: .normal)
            $0.backgroundColor = .red
            $0.addTarget(self, action: #selector(testBtn), for: .touchUpInside)
            $0.snp.makeConstraints { (make) in
                make.bottom.equalTo(-100)
                make.left.equalTo(100)
                make.right.equalTo(-100)
                make.height.equalTo(100)
            }
        }
        
//        ToastUtil.showLoading()
        
        XLog(AppConfig.appVersion)
        XLog(AppConfig.buildNumber)
        
//        login()
//        register()
//        gameInfo()
        let str = String("676374637.02")
        XLog("字符串加逗号：\(str.showInComma(source: str))")
        
        let str2 = String("0.0000")
        XLog("字符串去无效0：\(str2.decimalLogic())")

        let str3 = String("1888800.0010")
//        XLog("金额转越南金额：\(str3.convertVietnamNumber(gap: 0))")

        
        
        let uuid = UIDevice.chainKeyUUID
        XLog("uuid：\(uuid)")

    }
    
    @objc private func testBtn(){
        LogUtil.showLog()
    }
    
    func login() {
        ToastUtil.showLoading()
        Api.request(UserApi.login(name: "test001", pwd: "Aa123456")) { (result: ApiModel<BaseModel>) in
            ToastUtil.hide()
            if result.isSuccess {
                XLog(result)
            } else {
                ToastUtil.showMessage(result.msg)
            }
        }
    }
    
    func register() {
        ToastUtil.showLoading()
        let params: [String: Any] = [
            "id": "456323357218548212",
            "code": "DQSC",
            "name": "test001",
            "password1": "Aa123456",
            "password2": "Aa123456",
        ]
        Api.request(UserApi.register(params: params)) { (result: ApiModel<BaseModel>) in
            ToastUtil.hide()
            if result.isSuccess {
                XLog([result.data, result.object, result.array])
            } else {
                ToastUtil.showMessage(result.msg)
            }
        }
    }

    func creatyLbl(y: CGFloat, font: UIFont) -> UILabel {
        let test = UILabel(frame: CGRect(x: 100, y: y, width: 100, height: 30))
        test.text = "字体变化"
        test.font = font
        return test
    }
    
    func gameInfo() {
        ToastUtil.showLoading()
        Api.request(HomeApi.home, keyPath: "lpd") { (result: ApiModel<GameInfoModel>) in
            ToastUtil.hide()
            if result.isSuccess {
                XLog([result.data, result.object, result.array])
            } else {
                ToastUtil.showMessage(result.msg)
            }
        }
    }

}
