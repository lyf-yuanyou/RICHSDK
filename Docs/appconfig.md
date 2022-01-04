#  AppConfig

```swift
public typealias VoidBlock = () -> Void
public typealias BoolBlock = (Bool) -> Void
public typealias IntBlock = (Int) -> Void
public typealias DoubleBlock = (Double) -> Void
public typealias StringBlock = (String) -> Void
public typealias AnyBlock = (Any) -> Void

struct AppConfig {

    /// 系统环境
    enum State: Int {
        /// 测试环境
        case debug
        /// 正式环境
        case release
    }
    
    /// 环境变量debug/release
    static var state: State = .debug 

    /// 应用ID：com.dotdotbuy.DotdotBuy
    static let bundleId 

    /// 应用App Store中的ID
    static let appId 

    /// 应用App Store中的ID
    static let companyName 

    /// 应用App Store中的ID
    static let iTunesPath = "itms-apps://itunes.apple.com/app/id\(appId)"

    /// app版本号 eg:5.30.0
    static let appVersion 

    /// 帮助邮箱j02358@rich.work;
    static let helpMail
}

extension UIApplication {
    /// 应用ID：com.rich.richdemo
    static let bundleId = AppConfig.bundleId
    /// 应用App Store中的ID
    static let appId = AppConfig.appId
}
```

