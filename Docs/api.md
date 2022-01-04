#  Api网络请求

## 简述
网络模块是根据Alamofire定制的，数据模型转换放在网络里，简单易用。
<br>
网络错误定义：

```js
/// 请求失败错误类型
///
/// - noNetwork: 无网络
/// - timeout: 请求超时
/// - dataError: 解析数据失败
/// - serverError: 服务器错误，responseCode != 200
enum Error: Int {
    case noNetwork = -1000
    case timeout = -1001
    case dataError = -1002
    case serverError = -1003
}
```
<br>
loading可以放在网络中，多个请求或默认请求不能放在网络中，Loading定义如下：

```js
/// 请求时是否显示loading
///
/// - none: 不显示（默认选项）
/// - selfView: 显示在当前控制器view上，loading不会全屏覆盖（推荐）
/// - keyWindow: 顶级window上，如果请求事件过长用户无法操作（不建议）
/// - some(View): 在指定的view中显示loading
enum Loading<View> {
    /// 不显示（默认选项）
    case none
    /// 显示在当前控制器view上，loading不会全屏覆盖（推荐）
    case selfView
    /// 顶级window上，如果请求事件过长用户无法操作（不建议）
    case keyWindow
    /// 在指定的view中显示loading
    case some(View)
}
```

<br>
返回模型ApiModel定义:

```js
/// 状态码
var state: Int = 0

/// 错误信息
var msg: String = ""

/// 返回原始数据
var data: Any?

/// 返回转模型后的对象
var object: T?

/// 返回转模型后的对象数组
var array: [T]?

/// 是否成功请求到数据
var isSuccess: Bool { return self.state == Api.kSuccess }


/// 带模型转换的网络请求，模型是对象Object
///
/// - Parameters:
///   - urlRequest: 自定义请求对象
///   - keyPath: 对象路径keyPath，是从data后面key开始算起的
///   - loading: 是否显示loading
///   - completionHandler: 完成回调
/// - Returns: DataRequest，无网络时不执行请求返回nil
class func request<T: HandyJSON>(_ urlRequest: URLRequestConvertible,
                                 keyPath: String? = nil,
                                 loading: Loading<UIView> = .none,
                                 completionHandler: @escaping(_ result: ApiModel<T>) -> Void) -> DataRequest?
```

## 使用
- 创建Api接口，例如首页模块请求放在 `HomeApi` 中
- 创建数据模型，继承自 `HandyJSON`
- Controller中使用

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

