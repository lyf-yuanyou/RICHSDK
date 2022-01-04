//
//  MeVC.swift
//  richsdkdemo
//
//  Created by Apple on 2021/3/17.
//

import UIKit
import RICHSDK

class MeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getViewControllerName()
        
        self.addTextfile()
        
        print(Constants.richappKey)
    }

    /// 测试获取当前view所在VC的名称
    ///
    /// - Returns: nil
    func getViewControllerName() {
        let v = UIView()
        self.view.addSubview(v)
        XLog("当前Class名称是：\(MeVC.description() )")
        XLog("当前view所在VC的名称是：\(v.getViewController()?.className ?? "没获取到")")
    }
    
    
    /// IQKeyboardManagerSwift
    ///
    /// - Returns: nil
    func addTextfile() {
        let textFile = UITextField.init(frame: CGRect.init(x: 30, y: 400, width: 250, height: 44))
        textFile.placeholder = "测试IQKeyboardManagerSwift"
        self.view.addSubview(textFile)
    }

}

