#  PopAlert通用弹框

### 相关属性说明

```js
/// 弹框标题 eg:温馨提示
let title: String
/// 富文本-弹框标题 eg:温馨提示
let attrTitle: NSAttributedString?
/// 弹框内容
let subtitle: String?
/// 富文本-弹框内容
let attrSubtitle: NSAttributedString?
/// 取消按钮-取消
let cancelText: String?
/// 富文本-取消按钮-取消
let attrCancelText: NSAttributedString?
/// 确认按钮-确认
let confirmText: String?
/// 富文本-确认按钮-确认
let attrConfirmText: NSAttributedString?
/// 确定按钮回调
let block: VoidBlock
/// 取消按钮回调
@objc var cancelBlock: VoidBlock?
/// 当弹框内容有下划线链接时可以点击
@objc var textBlock: VoidBlock?
@objc var textAlignment: NSTextAlignment = .center
```

```js
case .showAlert:
    PopAlertView.showTipAlert(obj: PopAlertObj(title: "alert_title".localized(), subtitle: "子标题"))
case .showConfirm:
    let obj = PopAlertObj(title: "alert_title".localized(), subtitle: "你今天过得好吗？") {
        XLog("very fine!")
    }
    PopAlertView.showConfirmAlert(obj: obj)
```

![avatar](/image/popalert01.png)
<br>
<br>
![avatar](/image/popalert02.png)
<br>

