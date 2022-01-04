//
//  Storage.swift
//  richapp
//
//  Created by Apple on 2/6/21.
//

import Foundation

public class Storage {
    static let dataPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/data/"

    public static func set(_ value: String?, for key: String) {
        let manager = FileManager.default
        if !manager.fileExists(atPath: dataPath) {
            try? manager.createDirectory(at: URL(fileURLWithPath: dataPath), withIntermediateDirectories: true, attributes: nil)
        }
        let filePath = dataPath + key
        if manager.fileExists(atPath: filePath) {
            try? manager.removeItem(atPath: filePath)
        }
        if let data = value?.data(using: .utf8) {
            manager.createFile(atPath: filePath, contents: data, attributes: nil)
            if let data = manager.contents(atPath: filePath) {
                XLog(data)
            }
        }
    }

    public static func getData(key: String) -> Data? {
        let filePath = dataPath + key
        if FileManager.default.isReadableFile(atPath: filePath),
           let data = FileManager.default.contents(atPath: filePath) {
            return data
        }
        return nil
    }

    public static func getString(key: String) -> String? {
        if let data = getData(key: key), let string = String(data: data, encoding: .utf8) {
            return string
        }
        return nil
    }

    public static func getJson(key: String) -> [String: Any]? {
        if let string = getString(key: key),
           let json = try? JSONSerialization.jsonObject(with: string.data(using: .utf8)!, options: .fragmentsAllowed),
           let data = json as? [String: Any] {
            return data
        }
        return nil
    }
}
