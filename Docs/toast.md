#  ToastUtil

### 显示loading

```js
/// 显示Toast提示，记得在主线程调用不会帮你做容错处理
/// - Parameter view: 指定view，默认当前controller.view，生命周期超出当前页面时才keyWindow（慎用）
/// - Returns: IndicatorView 显示toast的view，非主线程或者应用还未初始化时调用返回nil
ToastUtil.showLoading()
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    ToastUtil.hide()
}
```

loading有两张样式，不需要显式指定系统会自动判断

```js
enum LoadingStyle {
    /// 整个控制器的 loading
    case pageLoading
    /// 局部 rect loading
    case smallRectLoading
}
```


### 显示msg

```
/// 在指定视图中显示toast文本提示
///
/// - Parameters:
///   - message: 要显示的内容
///   - inView: 在哪个视图上显示，默认(不传)是当前控制器view
///   - timeout: 显示时长默认2s
/// - Returns: UILabel
func showMessage(_ message: String?, inView: UIView?, timeout: TimeInterval)

ToastUtil.showMessage(result.msg)
```

常见用法：

```js
ToastUtil.showLoading()
Api.request(UserApi.login(name: "", code: ""), keyPath: "data.list") { (result: ApiModel<TempUserModel>) in
    ToastUtil.hide()
    if result.isSuccess {
        XLog([result.data, result.object, result.array])
    } else {
        ToastUtil.showMessage(result.msg)
    }
}
```


当请求失败是显式错误页面

```js
/// 在指定视图中显示数据加载失败
///
/// - Parameters:
///   - error: 错误对象
///   - view: 置顶视图
/// - Returns: IndicatorView
func showError(_ error: ServiceError, view: UIView) -> UIView
```

错误类型可自定义

```js
/// 加载失败错误类型
///
/// - normal: 普通错误，没有图标，提示语”网络错误“ + 按钮”重新加载“
/// - partial : 局部错误，用于视图页面中某一部分视图显示错误，”加载失败，点击重试“
/// - noNetwork: 网络错误，网络错误图标 + 提示语”网络错误“ + 按钮”重新加载“
/// - noNetwork: 网络错误，网络错误图标 + 提示语”没有数据“ + 按钮”重新加载“
/// - custom: 自定义错误
enum ErrorType: Int {
    /// default: 普通错误，通用错误图标 + 提示语”接口返回的错误提示“ + 按钮”重新加载“
    case `default`
    /// partial : 局部错误，用于视图页面中某一部分视图显示错误，”加载失败，点击重试“
    case partial
    /// noNetwork: 网络错误，网络错误图标 + 提示语”网络错误“ + 按钮”重新加载“
    case noNetwork
    /// noData: 网络错误，网络错误图标 + 提示语”没有数据“ + 按钮”重新加载“
    case noData
    /// custom: 自定义错误
    case custom
}
```



