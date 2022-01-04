#  Foundation扩展

### 日志输出

```js
/// 日志输出，正式环境会去掉不占用资源
///
/// - Parameters:
///   - message: 需要打印的内容
///   - file: 所在文件
///   - line: 行号
///   - method: 方法名
public func XLog(_ item: Any, file: String, function: String, line: Int)

```

### html富文本
```js
extension Data {
    /// 转html富文本
    var html2AttributedString: NSAttributedString
    /// 富文本转text
    var html2String: String
}
```


### zero清空末尾0
```js
extension BinaryFloatingPoint {
    /// 小数点后如果只是0，显示整数，如果不是，显示原来的值
    var cleanZero: String
}
```


### 获取类名
```js
extension NSObject {
    var className: String 
}
```


### DateFormatter
```js
extension DateFormatter {
    static let formatter = DateFormatter()
}
```


### 日期字符串格式化
```js
extension Double {

    /// 根据时间戳获取和格式获取对应的时间字符串
    ///
    /// - Parameter format: 日期格式化 yyyy-MM-dd HH:mm:ss
    /// - Returns: 2018-06-01 12:12:00
    func timeString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String 
}
```


## String扩展
### isValidURL
```js
/// 判断是否是有效的URL字符串
///
/// - Returns: true/false
func isValidURL() -> Bool
```


### getURLParams
```js
/// 获取URL路径中的参数
///
/// - Returns: 参数map
func getURLParams() -> [String: String]
```


### urlEncode
```js
/// 查询字符串编码
///
/// - Returns: urlEncode string
func urlEncode() -> String?
```


### matches文本正则表达式匹配
```js
/// 正则表达式匹配，能匹配到就返回true否则false
///
/// - Parameters:
///   - regex: 正则表达式
///   - options: 匹配规则
/// - Returns: true/false
func matches(regex: String, options: NSRegularExpression.Options) -> Bool 


/// 正则表达式替换
///
/// - Parameters:
///   - regex: 正则表达式
///   - replacement: 替换为字符
/// - Returns: 替换后的字符
func replacing(regex: String, with replacement: String) -> String
```


### URLString
```js
/// 如可以转换就转换链接，否则返回原字符串，不针对图片链接处理。图片链接转换参考imageURLString()
///
/// - Returns: 链接/原字符串
func URLString() -> String
```


### imageURLString
```js
/// 图片链接转换
///
/// - Returns: 图片链接/原字符串
func imageURLString() -> String
```


### 获取文本中的链接
```js
/// 获取文本中的链接
///
/// - Returns: 链接数组，未匹配到返回[]
func getLinks() -> [String]
```


### 获取HTML中的img标签和src内容
```js
/// 获取HTML中的img标签和src内容
///
/// - Returns: 返回元祖 (img标签数组, img的src属性数组)
func getLinksFromImgTag() -> (sources: [String], links: [String])
```


### 获取HTML中的a标签和src内容
```js
/// 获取HTML中的a标签和src内容
///
/// - Returns: 返回元祖 (a标签数组, a的src属性数组)
func getLinksFromATag() -> (sources: [String], links: [String])
```


### trim去除文本两端空白
```js
func trim() -> String
```

```js
var html2AttributedString: NSAttributedString?
```

```js
var html2String: String
```

### range & NSRange 互转
```js
/// range转换为NSRange
func nsRange(from range: Range<String.Index>) -> NSRange

/// NSRange转化为range
func range(from nsRange: NSRange) -> Range<String.Index>?
```


### 获取字符串MD5值
```js
func md5() -> String
```

### 截取字符串
```js
subscript(loc: Int) -> String

str[1]
```

### 截取字符串
```js
subscript(loc: Int, lenth: Int) -> String

str[2, 2]
```


### String sha1
```js
func sha1() -> String
```


### String sha256
```js
func sha256() -> String
```

### 根据UTC(2021-04-01T02:35:00.0000000-04:00)转换北京时间
```js
/// 根据UTC(2021-04-01T02:35:00.0000000-04:00)转换北京时间
///
/// - Parameters:
///   - format: 要转换的格式yyyyMMdd
/// - Returns: 转换后北京时间
func beijingTime(format: String) -> String
```


### boundingHeight
```js
/// 根据字体和宽度计算文本高度，如果是富文本属性请用自带的api实现
///
/// - Parameters:
///   - width: 宽度
///   - font: 字体
/// - Returns: 文本高度
func boundingHeight(width: CGFloat, font: UIFont) -> CGFloat
```


## Collection
### 集合元素下标安全访问，越界返回nil
```js
/// 集合元素下标安全访问，越界返回nil
subscript(safe index: Index) -> Element?

dataSource[safe: indexPath.section]
```



## Dictionary
### 字典转JSON string
```js
/// 字典转JSON string
///
/// - Parameters:
///   - prettyPrint: 是否prettyPrint
/// - Returns: JSON string
func toJSONString(prettyPrint: Bool = false) -> String?
```

