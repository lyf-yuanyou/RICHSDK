#  UIConfig

```js
extension UIDevice {
    /// 屏幕宽
    @objc static let width = UIScreen.main.bounds.width
    /// 屏幕高
    @objc static let height = UIScreen.main.bounds.height
    /// 是否为刘海屏
    @objc static let iPhoneXSeries = isiPhoneXSeries()
    /// 导航栏+状态栏高度
    @objc static let navBarHeight: CGFloat = (iPhoneXSeries ? 88 : 64)
    /// TabBar高度
    @objc static let tabBarHeight: CGFloat = (iPhoneXSeries ? 83 : 49)
    /// 状态栏高度
    @objc static let statusBarHeight: CGFloat = (iPhoneXSeries ? 44 : 20)
    /// 边缘间隙
    @objc static let kMargin: CGFloat = 14
    /// Tabbar底部间隙
    @objc static let kTabbarMargin: CGFloat = (iPhoneXSeries ? 34 : 0)
}

/// 占位图 方形
public let placeholderImage = UIImage(named: "ddb_image_default")
/// 占位图 矩形
public let placeholderImageRec = UIImage(named: "ddb_image_default_rec")
/// 占位图 用户头像
public let placeholderUserIcon = UIImage(named: "userHead_default")

public let appLogoUrl = "http://rich.com/images/app/icon.png"
```

