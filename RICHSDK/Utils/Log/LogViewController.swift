//
//  LogViewController.swift
//  RICHSDK
//
//  Created by Apple on 20/5/21.
//

import UIKit

class LogViewController: UIViewController {
    weak var logTextView: UITextView!
    weak var switchBtn: UISwitch!
    let serialQueue = DispatchQueue(label: "QueueLog")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "日志记录".localized()
        setupUI()
        readLog()
    }

    func setupUI() {
        let logTextView = UITextView(frame: CGRect(x: 0, y: UIDevice.navBarHeight, width: UIDevice.width, height: UIDevice.height - UIDevice.navBarHeight), textContainer: nil)
        logTextView.font = .systemFont(ofSize: 10)
        logTextView.textColor = .hex(0x333333)
        logTextView.isEditable = false
        view.addSubview(logTextView)
        self.logTextView = logTextView

        let switchBtn = UISwitch()
        switchBtn.isOn = UserDefaults.standard.bool(forKey: "showNetwork")
        switchBtn.addTarget(self, action: #selector(filterNetwork(_:)), for: .valueChanged)
        self.switchBtn = switchBtn
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "⏬", style: .plain, target: self, action: #selector(scrollToBottom)),
            UIBarButtonItem(customView: switchBtn)
        ]
    }

    @objc func scrollToBottom() {
        let offsetY = logTextView.contentSize.height - logTextView.bounds.size.height
        logTextView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: true)
    }

    @objc func filterNetwork(_ button: UISwitch) {
        UserDefaults.standard.setValue(button.isOn, forKey: "showNetwork")
        UserDefaults.standard.synchronize()
        readLog()
    }

    /// 读取log
    func readLog() {
        if !FileManager.default.fileExists(atPath: LogUtil.logFileURL.path) {
            logTextView.text = "日志文件不存在"
            return
        }
        if var text = try? String(contentsOf: LogUtil.logFileURL, encoding: .utf8) {
            logTextView.text = text
            if switchBtn.isOn {
                ToastUtil.showLoading()
                serialQueue.async { [weak self] in
                    guard let self = self else { return }
                    while self.queryRangeText(to: text) {
                        let startIndex = self.queryStartIndex(text: text)
                        guard let end = text.firstIndex(of: "🚀") else { return }
                        guard let range2 = text.range(of: "🚀end") else { return }
                        let endLength = text.distance(from: range2.lowerBound, to: range2.upperBound)
                        let endIndex = text.index(end, offsetBy: endLength)
                        let index = startIndex ..< endIndex
                        text.replaceSubrange(index, with: "")
//                        text.removeSubrange(index)
                        XLog("当前线程:\(Thread.current)")
                    }
                    DispatchQueue.main.async {
                        ToastUtil.hide()
                        self.logTextView.text = text
                    }
                }
            }
        }
    }
    /// 查询是否包含范围
    private func queryRangeText(to logText: String?) -> Bool {
        guard let logText = logText else { return false }
        return logText.contains("😂😂")
    }

    /// 查询起始位置
    private func queryStartIndex(text: String) -> String.Index {
        var first = false, second = false
        var startIndex = text.startIndex
        if let start1 = text.firstIndex(of: "😂") {
            first = true
            startIndex = start1
        }
        if let start2 = text.firstIndex(of: "😞") {
            second = true
            startIndex = start2
        }

        if first, second {
            let range1: Range = text.startIndex..<text.firstIndex(of: "😂")!
            let range2: Range = text.startIndex..<text.firstIndex(of: "😞")!
            let location1 = text.distance(from: text.startIndex, to: range1.lowerBound)
            let location2 = text.distance(from: text.startIndex, to: range2.lowerBound)
            if location1 < location2 {
                startIndex = text.firstIndex(of: "😂")!
            }
        }
        return startIndex
    }
}
