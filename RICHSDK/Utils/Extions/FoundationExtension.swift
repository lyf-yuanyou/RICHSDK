//
//  FoundationExtension.swift
//  richdemo
//
//  Created by Apple on 3/3/21.
//

import CommonCrypto
import UIKit

/// 日志输出，正式环境会去掉不占用资源
///
/// - Parameters:
///   - message: 需要打印的内容
///   - file: 所在文件
///   - line: 行号
///   - method: 方法名
public func XLog(_ item: Any, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    if let logStr = item as? String {
        let list = ["GetEventSummary", "GetEventsAndMarkets", "GetOutrights", "GetAllSportCount",
                    "GetEventInfoByPage", "GetLiveEventInfo", "GetOutrightEvents",
                    "GetSelectedEventInfo", "GetAllCompetitionCount"]
        if let _ = list.first(where: { logStr.contains($0) }) {
            return
        }
    }
    print("\(file.components(separatedBy: "/").last ?? file) \(function) \(line): \(item)")
    #endif
}

public extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(
                data: self,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
        } catch {
            XLog("html2AttributedString error:\(error.localizedDescription)")
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

// MARK: - BinaryFloatingPoint
public extension BinaryFloatingPoint {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self as! CVarArg) : "\(self)"
    }
}

public extension NSObject {
    var className: String {
        return Self.description()
    }
}

public extension DateFormatter {
    static let formatter = DateFormatter()
}

public extension Date {
    func strValue(dateFormat: String = "yyyy-MM-dd", isBeijing: Bool = true) -> String {
        let formatter = DateFormatter()
        if isBeijing {
            formatter.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)! // TimeZone(identifier: "EST")
            formatter.locale = Locale(identifier: "zh_CN")
        } else {
            formatter.timeZone = TimeZone.current
            formatter.locale = Locale.current
        }
        formatter.dateFormat = dateFormat
        let dateStr = formatter.string(from: self)
        return dateStr
    }
}

// MARK: - Double
public extension Double {
    /// 根据时间戳获取和格式获取对应的时间字符串
    ///
    /// - Parameter format: 日期格式化 yyyy-MM-dd HH:mm:ss
    /// - Returns: 2018-06-01 12:12:00
    func timeString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        DateFormatter.formatter.timeZone = TimeZone(secondsFromGMT: 8 * 60 * 60)
        DateFormatter.formatter.dateFormat = format
        return DateFormatter.formatter.string(from: Date(timeIntervalSince1970: self))
    }
}

// MARK: - String
public extension String {
    /// 判断是否是有效的URL字符串
    ///
    /// - Returns: true/false
    func isValidURL() -> Bool {
        if let url = URL(string: self), let _ = url.scheme, let _ = url.host {
            return true
        }
        return false
    }

    /// 获取URL路径中的参数
    ///
    /// - Returns: 参数map
    func getURLParams() -> [String: String] {
        var map: [String: String] = [:]
        if let range = self.range(of: "?") {
            self.suffix(from: range.upperBound).split(separator: "&").forEach({
                let array = $0.split(separator: "=")
                if let key = array.first, let value = array.last, !key.isEmpty {
                    map[String(key)] = String(value)
                }
            })
        }
        return map
    }

    /// 查询字符串编码
    ///
    /// - Returns: urlEncode string
    func urlEncode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    /// 正则表达式匹配，能匹配到就返回true否则false
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配规则
    /// - Returns: true/false
    func matches(regex: String, options: NSRegularExpression.Options) -> Bool {
        if let pattern = try? NSRegularExpression(pattern: regex, options: options) {
            return (pattern.numberOfMatches(in: self,
                                            options: .reportCompletion,
                                            range: NSRange(location: 0, length: self.count)) > 0)
        } else {
            return false
        }
    }

    /// 正则表达式替换文本
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - options: 匹配规则
    ///   - replacement: 替换文本
    /// - Returns: 替换后的文本
    func stringByReplacing(regex: String, options: NSRegularExpression.Options, replacement: String) -> String {
        if let pattern = try? NSRegularExpression(pattern: regex, options: options) {
            return pattern.stringByReplacingMatches(in: self,
                                                    options: .reportCompletion,
                                                    range: NSRange(location: 0, length: self.count),
                                                    withTemplate: replacement)
        } else {
            return self
        }
    }

    /// 如可以转换就转换链接，否则返回原字符串，不针对图片链接处理。图片链接转换参考imageURLString()
    ///
    /// - Returns: 链接/原字符串
    func URLString() -> String {
        var result: String = self
        if self.hasPrefix("//") {
            result = "http:" + self
        }
        return result
    }

    /// 图片链接转换
    ///
    /// - Returns: 图片链接/原字符串
    func imageURLString() -> String {
        var result: String = self
        if self.hasPrefix("//") {
            result = self.URLString()
        }
        return result
    }

    /// 正则表达式替换
    ///
    /// - Parameters:
    ///   - regex: 正则表达式
    ///   - replacement: 替换为字符
    /// - Returns: 替换后的字符
    func replacing(regex: String, with replacement: String) -> String {
        if let pattern = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) {
            return pattern.stringByReplacingMatches(in: self,
                                                    options: .reportCompletion,
                                                    range: NSRange(location: 0, length: self.count),
                                                    withTemplate: replacement)
        } else {
            return self
        }
    }

    /// 获取文本中的链接
    ///
    /// - Returns: 链接数组，未匹配到返回[]
    func getLinks() -> [String] {
        var links: [String] = []
        if let pattern = try? NSRegularExpression(pattern: "[a-zA-z]+://[^\\s]*", options: .caseInsensitive) {
            let results = pattern.matches(in: self,
                                          options: .reportCompletion,
                                          range: NSRange(location: 0, length: self.count))
            for text in results {
                for idx in 0..<text.numberOfRanges {
                    let range = text.range(at: idx)
                    if let url = (self as NSString).substring(with: range).urlEncode() {
                        XLog("range=\(range) link:\(url)")
                        links.append(url)
                    }
                }
            }
        }
        return links
    }

    /// 获取HTML中的img标签和src内容
    ///
    /// - Returns: 返回元祖 (img标签数组, img的src属性数组)
    func getLinksFromImgTag() -> (sources: [String], links: [String]) {
        // bug:😏遇到表情字符会解析出问题，➕" "解决
        let originString = " \(self) "
        let regexImgSrc = "<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>"
        var sources: [String] = []
        var links: [String] = []
        if let pattern = try? NSRegularExpression(pattern: regexImgSrc, options: .caseInsensitive) {
            let results = pattern.matches(in: originString,
                                          options: .reportCompletion,
                                          range: NSRange(location: 0, length: originString.count))
            for text in results {
                for idx in 0..<text.numberOfRanges {
                    let url = (originString as NSString).substring(with: text.range(at: idx))
                    idx.isMultiple(of: 2) ? sources.append(url) : links.append(url)
                }
            }
        }
        return (sources, links)
    }

    /// 获取HTML中的a标签和src内容
    ///
    /// - Returns: 返回元祖 (a标签数组, a的src属性数组)
    func getLinksFromATag() -> (sources: [String], links: [String]) {
        let originString = " \(self) "
        let regexImgSrc = "<a[^>]+href\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>"
        var sources: [String] = []
        var links: [String] = []
        if let pattern = try? NSRegularExpression(pattern: regexImgSrc, options: .caseInsensitive) {
            let results = pattern.matches(in: originString,
                                          options: .reportCompletion,
                                          range: NSRange(location: 0, length: originString.count))
            for text in results {
                for idx in 0..<text.numberOfRanges {
                    let url = (originString as NSString).substring(with: text.range(at: idx))
                    idx.isMultiple(of: 2) ? sources.append(url) : links.append(url)
                }
            }
        }
        return (sources, links)
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }

    /// range转换为NSRange
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    /// NSRange转化为range
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let fromIndex = String.Index(from16, within: self),
            let toIndex = String.Index(to16, within: self)
            else { return nil }
        return fromIndex ..< toIndex
    }

    /// 截取字符串
    subscript(loc: Int) -> String {
         let startIndex = self.index(self.startIndex, offsetBy: loc)
        return String(self[startIndex..<self.endIndex])
    }

    /// 截取字符串
    subscript(loc: Int, lenth: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: loc)
        let endIndex = self.index(self.startIndex, offsetBy: loc + lenth)
        return String(self[startIndex..<endIndex])
    }

    /// 根据字体和宽度计算文本高度，如果是富文本属性请用自带的api实现
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - font: 字体
    /// - Returns: 文本高度
    func boundingHeight(width: CGFloat, font: UIFont) -> CGFloat {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                 attributes: [.font: font], context: nil).size.height
    }

    func boundingWidth(fontSize: CGFloat) -> CGFloat {
           let font = UIFont.systemFont(ofSize: fontSize)
        let rect = NSString(string: self).boundingRect(
            with: CGSize(width: CGFloat(MAXFLOAT), height: 20),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font], context: nil)
           return ceil(rect.width)
       }

    /// 根据UTC(2021-04-01T02:35:00.0000000-04:00)转换北京时间
    ///
    /// - Parameters:
    ///   - format: 要转换的格式yyyyMMdd
    /// - Returns: 转换后北京时间
    func beijingTime(format: String) -> String {
        // 2021-04-01T02:35:00.0000000-04:00
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = self.count > 25 ? [.withInternetDateTime, .withFractionalSeconds] : .withInternetDateTime
        if let date = iso8601Formatter.date(from: self) {
            let formatter = DateFormatter.formatter
            formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
        return self
    }

    /// 根据UTC(2021-04-01T02:35:00.0000000-04:00)转换当前时区时间
    ///
    /// - Parameters:
    ///   - format: 要转换的格式yyyyMMdd
    /// - Returns: 转换后当前时区时间
    func iso8601Time(format: String) -> String {
        // 2021-04-01T02:35:00.0000000-04:00
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = self.count > 25 ? [.withInternetDateTime, .withFractionalSeconds] : .withInternetDateTime
        if let date = iso8601Formatter.date(from: self) {
            let formatter = DateFormatter.formatter
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
        return self
    }

    ///    将字符串每隔数位用分割符隔开(加逗号)
    ///  - Parameters:
    ///   - param source 目标字符串
    ///   - param gap    相隔位数，默认为3 ，，如果传0就不分隔了
    ///   - param seperator    分割符，默认为逗号
    ///   - return       用指定分隔符每隔指定位数隔开的字符串
    func showInComma(source: String?, gap: Int = 3, seperator: Character = ",") -> String {
        var temp = self
        if let source = source {
            temp = source
        }
        // 如果是0，就不分隔了
        if gap == 0 {
            return temp
        }
        var suffix = ""
        // 如果包含小数点，先分割
        if temp.contains(".") {
            let arr = temp.split(separator: ".")
            temp = String(arr[0])
            suffix = "." + String(arr[1])
        }

        // 获取目标字符串的长度
        let count = temp.count
        // 计算需要插入的【分割符】数
        let sepNum = count / gap
        // 若计算得出的【分割符】数小于1，则无需插入
        guard sepNum >= 1 else {
            return temp + suffix
        }
        // 插入【分割符】
        for i in 1...sepNum {
            // 计算【分割符】插入的位置
            let index = count - gap * i
            /* 若计算得出的【分隔符】的位置等于0，则说明目标字符串的长度为【分割位】的整数倍，如将【123456】分割成【123,456】，此时如果再插入【分割符】，则会变成【,123,456】 */
            guard index != 0 else {
                break
            }
            // 执行插入【分割符】
            temp.insert(seperator, at: temp.index(temp.startIndex, offsetBy: index))
        }
        return temp + suffix
    }

    ///    字符串小数后面无效0处理
    ///  - Parameters:
    ///   - param significand 保留小数位数
    ///   - return  去除无效0后的字符串
    func decimalLogic() -> String {
        var outNumber = self
        let numberString = self

        var i = 1

        if numberString.contains(".") {
            while i < numberString.count {
                if outNumber.hasSuffix("0") {
                    outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
                    i += 1
                } else {
                    break
                }
            }
            if outNumber.hasSuffix(".") {
                outNumber.remove(at: outNumber.index(before: outNumber.endIndex))
            }
            return outNumber
        } else {
            return numberString
        }
    }

    /// 返回整数
    /// - Parameter isRound: 是否四舍五入
    /// - Returns: 返回处理之后的整数
    func clearnDecimal(_ isRound: Bool = false) -> String {
        if isRound {
            let doubleValue = Double(self) ?? 0
            return String(format: "%.0f", doubleValue)
        }
        if let pointLocal = self.range(of: ".") {
            let pointRange = self.nsRange(from: pointLocal)
            return self[0, pointRange.location]
        }
        return self
    }

    ///     金额格式化，根据语言格式化
    ///  - Parameters:
    ///   - param  gap    相隔位数，默认为3 ，，如果传0就不分隔了
    ///   - param  seperator    分割符，默认为逗号
    ///   - return  格式化后的字符串
    func toMoney(gap: Int = 3, seperator: Character = ",") -> String {
        switch Localized.language {
        case .vietnam:
            return self.decimalLogic().showInComma(source: nil, gap: gap, seperator: seperator) + "K"
        default:
            return self.showInComma(source: nil, gap: gap, seperator: seperator)
        }
    }

    /// 根据字符串生成二维码
    /// - Parameters:
    ///   - waterImage: 水印图片，此参数若为空则不会显示水印
    ///   - ctColor: 内容颜色
    ///   - bgColor: 背景颜色
    /// - Returns: 返回二维码图片
    func creatQRCodeImage(waterImage: UIImage? = nil, ctColor: UIColor = .black, bgColor: UIColor = .white) -> UIImage {
        // 创建过滤器
        let filter = CIFilter(name: "CIQRCodeGenerator")
        // 过滤器恢复默认
        filter?.setDefaults()
        // 将string转换成data类型
        let data = self.data(using: .utf8, allowLossyConversion: true)
        // 设置容错率
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        // 设置内容
        filter?.setValue(data, forKey: "inputMessage")
        // 获取二维码过滤器生成的二维码
        guard let image = filter?.outputImage else {
            return UIImage()
        }

        // 设置颜色过滤器
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(image, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: ctColor), forKey: "inputColor0")
        colorFilter.setValue(CIColor(color: bgColor), forKey: "inputColor1")
        guard let colorCIImg = colorFilter.outputImage else {
            return UIImage()
        }
        // 添加颜色滤镜
        var finalImg = UIImage(ciImage: colorCIImg).scaleToSize(size: CGSize(width: 150, height: 150))

        if let currentWaterImg = waterImage {
            // 根据二维码图片设置生成水印图片rect
            let waterImageRect = getWaterImageRect(image: finalImg)
            let logoImage = currentWaterImg.scaleToSize(size: waterImageRect.size)
            // 生成水印图片 rect 从00 开始
            let finalWaterImage = logoImage.clipImageRadious(
                rect: CGRect(x: 0, y: 0, width: waterImageRect.size.width, height: waterImageRect.size.height),
                radious: 4, borderW: 2, borderColor: .white)
            // 添加水印图片
            finalImg = finalImg.addWaterImage(waterImage: finalWaterImage, rect: waterImageRect)
        }
        return finalImg
    }

    // 根据二维码图片设置生成水印图片rect 这里限制水印的图片为二维码的1/4
    private func getWaterImageRect(image: UIImage) -> CGRect {
        let linkSize = CGSize(width: image.size.width / 4, height: image.size.height / 4)
        let linkX = (image.size.width - linkSize.width) / 2
        let linkY = (image.size.height - linkSize.height) / 2
        return CGRect(x: linkX, y: linkY, width: linkSize.width, height: linkSize.height)
    }
}

public extension String {
    /// 获取字符串MD5值
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(format: hash as String)
    }

    /// String sha1
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

// MARK: - Collection
public extension Collection {
    /// 集合元素下标安全访问，越界返回nil
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - Dictionary
public extension Dictionary {
    /// 字典转JSON string
    ///
    /// - Parameters:
    ///   - prettyPrint: 是否prettyPrint
    /// - Returns: JSON string
    func toJSONString(prettyPrint: Bool = false) -> String? {
        if JSONSerialization.isValidJSONObject(self),
           let jsonData = try? JSONSerialization.data(withJSONObject: self, options: prettyPrint ? .prettyPrinted : []) {
            return String(data: jsonData, encoding: .utf8)
        }
        XLog("\(self)) is not a valid JSON Object")
        return nil
    }
}
