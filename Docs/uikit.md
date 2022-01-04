#  UIKit扩展


## UIView扩展
### showPop在指定View上动画显示或关闭弹窗
```js
/// 在指定View上动画显示或关闭弹窗
/// - Parameters:
///   - inView: 在指定View上显示弹窗，当isShow=false时可为nil
///   - widthFactor: view宽度系数[0.1, 1]表示widthFactor*deviceWidth，如果值为[100, deviceWidth]表示所有机型都一样的宽度，如果不设置widthFactor则用自身的宽
///   - tapMaskClose: true:点击mask蒙版执行isShow=false操作 false:必须点关闭按钮才能关闭弹窗，当isShow=false时可为nil
func showPop(inView: UIView?, widthFactor: CGFloat, tapMaskClose: Bool)


/// 关闭弹窗
func closePop(completionBlock: VoidBlock?)
```

### UIView点击事件
```js
func addTap(handler: ((_ sender: UITapGestureRecognizer) -> Void)?) -> UITapGestureRecognizer?
```


### 获取view的x/y/width/height
```js
var x: CGFloat
var y: CGFloat
var width: CGFloat
var height: CGFloat
```


### stack view 布局
```js
/// stack view 布局
///
/// - Parameters:
///   - items: 要布局的子视图集合，须先添加进父视图中才能布局
///   - spacing: 间距
///   - margin: 边缘
func stackHerizontal(_ items: [UIView], _ spacing: CGFloat, _ margin: CGFloat) 


func stackVertical(_ items: [UIView], _ spacing: CGFloat, _ margin: CGFloat)
```

### 添加边框
```js
/// 单实线样式
///
/// - top: 顶部
/// - right: 右边
/// - bottom: 底部
/// - left: 左边
/// - all: 边框
enum BorderEdge: Int {
    case top, right, bottom, left, all
}

/// 圆角边框类型
///
/// - none: 不显示边框
/// - solid: 实线[width:线宽, color:线条颜色,]
/// - dash: 虚线[width:线宽, color:线条颜色, pattern:样式]
enum BorderType {
    /// 不显示边框
    case none
    /// 实线[width:线宽, color:线条颜色,]
    case solid(width: CGFloat, color: UIColor)
    /// 虚线[width:线宽, color:线条颜色, pattern:样式]
    case dash(width: CGFloat, color: UIColor, pattern: [NSNumber]?)
}

/// 给view添加边框
///
/// - Parameter edge: 给哪一条边加边框
/// - Parameter border: 边框样式
func addBorder(edge: BorderEdge = .all, border: BorderType)


/// 指定位置切圆角
///
/// - Parameters:
///   - corners: 需要切的角
///   - cornerRadii: 圆角半径
///   - border: 圆角边框类型 BorderType，默认不显示边框
func bezierCorner(corners: UIRectCorner, cornerRadii: CGSize, border: BorderType = .none)
```


### bezier圆角
```js
/// 指定位置切圆角
///
/// - Parameters:
///   - view: 切圆角的view
///   - corners: 需要切的角
///   - cornerRadii: 圆角半径
static func bezierCorner(view: UIView, corners: UIRectCorner, cornerRadii: CGSize)
```

### UIView生成image
```js
/// UIView生成指定区域image
///
/// - Parameters:
///   - rect: 指定生成区域，默认就是UIView的截图
func asImage(rect: CGRect? = nil) -> UIImage
```

### xib中设置阴影颜色
```js
var shadowColor: UIColor?
```

### xib中设置边框颜色
```js
var borderColor: UIColor?
```


## UINavigationController

### Pop到前N个控制器
```js
/// Pop到前N个控制器
///
/// - Parameter index: 控制器栈中倒数第几个
func popViewController(atLast index: Int)
```


## UITableView

### Inset
```js
/// 标准间距 10
static let sectionInset: CGFloat = 10.0
/// section 间距 0
static let zeroInset: CGFloat = 0.001
```

### 高度为0的cell （自动布局）
```js
/// 高度为0的cell （自动布局）
static var emptyCell: UITableViewCell
```

## UIApplication
### 获取当前topViewController
```js
/// 获取当前topViewController
static var topViewController: UIViewController?
```

## UIImageView
### image动画 瞬间放大缩小
```js
func playBounce()
```


## UIImage
### compressQuality压缩到指定大小
```js
func compressQuality(maxLength: Int) -> Data
```

### 缩放到指定width
```js
func scaleImage(width: CGFloat) -> UIImage
```


## UIColor
### UIColor.hex(0xffffff)
```js
static func hex(_ value: Int, _ alpha: CGFloat) -> UIColor 
```

### UIColor.hex("#ffffff")/.hex("#ffffff00")/.hex("ffffff")/.hex("ffffff00")
```js
static func hex(_ hexStr: String, _ alpha: CGFloat = 1.0) -> UIColor 
```

## UIFont
### 快捷设置苹方字体
```js
static func font(custom name: FontName, _ size: CGFloat = 14) -> UIFont
```


## MJCustomGifHeader
### 下拉刷新自定义动画
```js
/// 添加header下拉刷新（品牌logo帧动画）
scrollView.addHeaderRefresh {}
/// 添加header下拉刷新（转圈动画）
scrollView.addRoaHeaderRefresh {}
/// 添加footer上拉加载更多动画
scrollView.addFotterRefresh {}

```



## FloatingButton,GIF浮动按钮
```js
floatingButton = FloatingButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100)).then {
    self.view.addSubview($0)
    $0.onClicked = {
        print("button clicked")
    }
}
```

## DropdownMenu用法
```js
let menuData : [(type: MenuType, items: [String])] = [
    (type:MenuType.normal, items:["全部", "存款", "取款", "转账", "红利", "返水", "加币", "减币", "调整"]),
    (type:MenuType.normal, items:["选项1", "选项2", "选项3", "选项4", "选项5", "选项6", "选项7"]),
    (type:MenuType.dateCustomize, items:["今日", "近7日", "近15日", "本月", "自定义"]),
]

let _ = DropdownMenu(frame: .zero, menuDatas: menuData).then {
    view.addSubview($0)
    $0.backgroundColor = .yellow
    $0.itemHideSetting = MenuHiddenSetting(des: 2, hidden: true, source: 1, sourceItem: 2) //第三个菜单默认隐藏，并且第二个菜单选中第二项时为隐藏
    $0.snp.makeConstraints { (make) in
        make.left.top.right.equalTo(view.safeAreaLayoutGuide)
        make.height.equalTo(40)
    }
    $0.onSelect = { indexMenu, indexItem, item in
        print("\(indexMenu) \(indexItem) \(item)")
    }
}
```
## YMTestView用法
```js
let _ = YMTextView().then {
    self.view.addSubview($0)
    $0.placeholder = "这是测试用的PLACEHOLDER"
    $0.maxCharacatorCount = 30
    $0.font = UIFont.systemFont(ofSize: 12)
    $0.placeholderColor = .lightGray
    $0.cntColor = .red
    $0.snp.makeConstraints { (make) in
        make.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
        make.height.equalTo(100)
    }
}
```



## YMTabBarController用法
```js
let tab = YMTabBarController()
tab.tabBarBorderColor = .lightGray
tab.tabBarShadowColor = .lightGray
```





## UIViewController
### 强制横屏/竖屏
```js
/// 强制横屏/竖屏
///
/// - Parameter orientation: 旋转的方向 [portrait, landscapeLeft, landscapeRight]
func forceOrientation(_ orientation: UIInterfaceOrientation)
```




## BaseTextView
### 带placeholder的UITextView
```js
继承BaseTextView
@IBInspectable var placeholder: String = ""
@IBInspectable var placeholderColor: UIColor = .lightGray
```



## Swift无限轮播框架
### CycleScrollView
```js
轻量级CycleScrollView
```



















