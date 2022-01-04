//
//  LogUtil.swift
//  RICHSDK
//
//  Created by Apple on 20/5/21.
//

import UIKit

public struct LogUtil {
    private static let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    static let logFileURL = cachePath.appendingPathComponent("log.txt")
//    public static var dotShowNetworkLog: Bool = false

    // 在文件末尾追加新内容
    static func appendLogFile(_ log: String) {
        do {
            let showNetworkLog = UserDefaults.standard.bool(forKey: "showNetwork")
            if showNetworkLog, log.hasPrefix("Api.swift") {
                return
            }
            // 如果文件不存在则新建一个
            if !FileManager.default.fileExists(atPath: logFileURL.path) {
                FileManager.default.createFile(atPath: logFileURL.path, contents: nil)
            }

            let fileHandle = try FileHandle(forWritingTo: logFileURL)
            let stringToWrite = "\n" + log

            // 找到末尾位置并添加
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
        } catch let error as NSError {
            print("failed to append: \(error)")
        }
    }

    public static func showLog() {
        UIApplication.topViewController?.show(LogViewController(), sender: nil)
    }
}
