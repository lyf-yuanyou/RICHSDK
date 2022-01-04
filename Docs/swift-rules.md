# Swift编码规范

## 编码正确性
- 努力使代码在编译器中没有错误❌、没有警告⚠️
- 可以使用`SwiftLint`辅助工具检查、格式化代码，提交代码前必须编译通过

## 命名
命名要易于理解，一些要点可以参考官方文档 [Api设计规范](https://swift.org/documentation/api-design-guidelines/)

- 命名易懂且最少4个字母，禁止中文、符号、数字
- 使用驼峰命名法 `camelCase` (非 `snake_case`)
- 使用 `UpperCamelCase` 命名类型和协议, `lowerCamelCase` 命名其他的例如变量等
- 使用基于角色而不是类型的名称
- 从`make`或`factory`开始工厂方法
- 动词方法遵循-ed，-ing规则
- 名词方法遵循formX规则或变异版本
- 避免返回值过载，可用对象或元组包装
- 使用元组时必须要显式参数前缀，元组参数不能过多
- 利用默认参数

### 类前缀

Swift类型由包含它们的模块自动命名，有命名空间的这点和OC不同，因此您不应添加类前缀（例如YM）<br>
如果来自不同模块的两个名称冲突，则可以通过在类型名称前添加模块名称来消除歧义，这种情况比较少出现

```swift
import SomeModule

let myClass = MyModule.UsefulClass()
```

### 代理

创建自定义代理方法时，未命名的第一个参数应该是代理源（UIKit有示例）

**推荐**:
```swift
func namePickerView(_ namePickerView: NamePickerView, didSelectName name: String)
func namePickerViewShouldReload(_ namePickerView: NamePickerView) -> Bool
```

**不允许**:
```swift
func didSelectName(namePicker: NamePickerViewController, name: String)
func namePickerShouldReload() -> Bool
```

### 使用类型推断

使用编译器类型推断上下文减少代码冗余

**推荐**:
```swift
let selector = #selector(viewDidLoad)
view.backgroundColor = .red
let toView = context.view(forKey: .to)
let view = UIView(frame: .zero)
```

**不允许**:
```swift
let selector = #selector(ViewController.viewDidLoad)
view.backgroundColor = UIColor.red
let toView = context.view(forKey: UITransitionContextViewKey.to)
let view = UIView(frame: CGRect.zero)
```

### 通用类型

通用类型参数应为描述性的大写驼峰名称。 当类型名称没有有意义的关系或作用时，请使用传统的单个大写字母，例如“ T”，“ U”或“ V”。

**推荐**:
```swift
struct Stack<Element> { ... }
func write<Target: OutputStream>(to target: inout Target)
func swap<T>(_ a: inout T, _ b: inout T)
```

**不允许**:
```swift
struct Stack<T> { ... }
func write<target: OutputStream>(to target: inout target)
func swap<Thing>(_ a: inout Thing, _ b: inout Thing)
```

## 组织代码

使用扩展将代码组织到功能的逻辑块中。 每个扩展名都应带有`// MARK：-`注释，以使事情井井有条。

### 协议一致性

为协议方法添加单独的扩展，也是按功能分类

**推荐**:
```swift
class MyViewController: UIViewController {
  // class stuff here
}

// MARK: - UITableViewDataSource
extension MyViewController: UITableViewDataSource {
  // table view data source methods
}

// MARK: - UIScrollViewDelegate
extension MyViewController: UIScrollViewDelegate {
  // scroll view delegate methods
}
```

**不允许**:
```swift
class MyViewController: UIViewController, UITableViewDataSource, UIScrollViewDelegate {
  // all methods
}
```

### 未使用代码

未使用的代码一律去除

**推荐**:
```swift
override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  return Database.contacts.count
}
```

**不允许**:
```swift
override func didReceiveMemoryWarning() {
  super.didReceiveMemoryWarning()
  // Dispose of any resources that can be recreated.
}

override func numberOfSections(in tableView: UITableView) -> Int {
  // #warning Incomplete implementation, return the number of sections
  return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  // #warning Incomplete implementation, return the number of rows
  return Database.contacts.count
}

```
### 最小化 Import

只用到`Foundation`就不要导入`UIKit`，用到了`UIKit`就不要导入`Foundation`

**推荐**:
```
import UIKit
var view: UIView
var deviceModels: [String]
```

**推荐**:
```
import Foundation
var deviceModels: [String]
```

**不允许**:
```
import UIKit
import Foundation
var view: UIView
var deviceModels: [String]
```

**不允许**:
```
import UIKit
var deviceModels: [String]
```

## 空格

记住tab不是空格，使用4格的tab不要2格的

**推荐**:
```swift
if user.isHappy {
    // Do something
} else {
    // Do something else
}
```

**不允许**:
```swift
if user.isHappy
{
  // Do something
}
else {
  // Do something else
}
```
三元运算符 `? :` 必须有空格隔开

**推荐**:
```swift
class TestDatabase: Database {
    var data: [String: CGFloat] = ["A": 1.2, "B": 3.2]
    var arrayOne: [String] = []
}
```

**不允许**:
```swift
class TestDatabase : Database {
    var data :[String:CGFloat] = ["A" : 1.2, "B":3.2]
    var arrayOne = Array<String>()
    var arrayTwo = [String]()
}
```

* 一行过长的语句应该用括号括起来

* 避免末尾过多空行

* 文件末尾添加一空行

## 注释

类、方法、变量前注释 `///` <br>
行内注释 `//` , 最好不用 `/*    */`

## 类和结构

尽量用 `struct` 少用 `class` <br>
`class` 尽量不要继承 `NSObject` 因为是纯Swift项目不需要给OC调用，更不要 `dynamic`

### 示例

```swift
class Circle: Shape {
  var x: Int, y: Int
  var radius: Double
  var diameter: Double {
    get {
      return radius * 2
    }
    set {
      radius = newValue / 2
    }
  }

  init(x: Int, y: Int, radius: Double) {
    self.x = x
    self.y = y
    self.radius = radius
  }

  convenience init(x: Int, y: Int, diameter: Double) {
    self.init(x: x, y: y, radius: diameter / 2)
  }

  override func area() -> Double {
    return Double.pi * radius * radius
  }
}

extension Circle: CustomStringConvertible {
  var description: String {
    return "center = \(centerString) area = \(area())"
  }
  private var centerString: String {
    return "(\(x),\(y))"
  }
}
```

### self使用

为简洁起见，请避免使用`self`，因为Swift不需要它访问对象的属性或调用其方法


### 计算型属性

**推荐**:
```swift
var diameter: Double {
  return radius * 2
}
```

**不允许**:
```swift
var diameter: Double {
  get {
    return radius * 2
  }
}
```

### Final

```swift
// Turn any generic type into a reference type using this Box class.
final class Box<T> {
  let value: T
  init(_ value: T) {
    self.value = value
  }
}
```

## 函数声明

将简短的函数声明放在一行中，包括左括号

```swift
func reticulateSplines(spline: [Double]) -> Bool {
  // reticulate code goes here
}
```

参数过多请换行

```swift
func reticulateSplines(
  spline: [Double], 
  adjustmentFactor: Double,
  translateConstant: Int, 
  comment: String
) -> Bool {
  // reticulate code goes here
}
```

用 `Void` 代替 `()`

**推荐**:

```swift
func updateConstraints() -> Void {
  // magic happens here
}

typealias CompletionHandler = (result) -> Void
```

**不允许**:

```swift
func updateConstraints() -> () {
  // magic happens here
}

typealias CompletionHandler = (result) -> ()
```

## 函数调用

一行这样写

```swift
let success = reticulateSplines(splines)
```

多行这样写

```swift
let success = reticulateSplines(
  spline: splines,
  adjustmentFactor: 1.3,
  translateConstant: 2,
  comment: "normalize the display")
```

## 闭包Closure

仅当参数列表末尾有单个闭包表达式参数时，才使用尾随闭包语法。 

为闭包参数指定描述性名称，如果参数未使用也可以用 `_`

**推荐**:
```swift
UIView.animate(withDuration: 1.0) {
  self.myView.alpha = 0
}

UIView.animate(withDuration: 1.0, animations: {
  self.myView.alpha = 0
}, completion: { finished in
  self.myView.removeFromSuperview()
})
```

**不允许**:
```swift
UIView.animate(withDuration: 1.0, animations: {
  self.myView.alpha = 0
})

UIView.animate(withDuration: 1.0, animations: {
  self.myView.alpha = 0
}) { f in
  self.myView.removeFromSuperview()
}
```

单行语句不需要return

```swift
attendeeList.sort { a, b in
  a > b
}

attendeeList.sort { > }
```

下面太长的话建议换行，自行把握

```swift
let value = numbers.map { $0 * 2 }.filter { $0 % 3 == 0 }.index(of: 90)

let value = numbers
  .map {$0 * 2}
  .filter {$0 > 50}
  .map {$0 + 10}
```

## 类型

Always use Swift's native types and expressions when available. Swift offers bridging to Objective-C so you can still use the full set of methods as needed.

**推荐**:
```swift
let width = 120.0                                    // Double
let widthString = "\(width)"                         // String
let height: Double = 120.0                           // Double
```

**不推荐**:
```swift
let width = 120.0                                    // Double
let widthString = (width as NSNumber).stringValue    // String
```

**不允许**:
```swift
let width: NSNumber = 120.0                          // NSNumber
let widthString: NSString = width.stringValue        // NSString
```
在绘图或布局代码中为了减少转化推荐用 `CGFloat`

### Constants

常量用 `let` 变量用 `var`

全局常量 `static let` 

**推荐**:
```swift
enum Math {
  static let e = 2.718281828459045235360287
  static let root2 = 1.41421356237309504880168872
}

let hypotenuse = side * Math.root2

```
**Note:** 同类型的常量加上命名空间

**不允许**:
```swift
let e = 2.718281828459045235360287  // pollutes global namespace
let root2 = 1.41421356237309504880168872

let hypotenuse = side * root2 // what is root2?
```

### 可选值

将变量和函数返回类型声明为可选的 `?` ，其中 `nil` 值是可接受的

`viewDidLoad()` 中不要强制解包 `model.name!`

```swift
textContainer?.textLabel?.setNeedsDisplay()
```

当一次解包并执行多个操作更方便时，请使用可选绑定：

```swift
if let textContainer = textContainer {
  // do many things with textContainer
}
```

**推荐**:
```swift
var subview: UIView?
var volume: Double?

// later on...
if let subview = subview, let volume = volume {
  // do something with unwrapped subview and volume
}

// another example
resource.request().onComplete { [weak self] response in
  guard let self = self else { return }
  let model = self.updateModel(response)
  self.updateUI(model)
}
```

**不允许**:
```swift
var optionalSubview: UIView?
var volume: Double?

if let unwrappedSubview = optionalSubview {
  if let realVolume = volume {
    // do something with unwrappedSubview and realVolume
  }
}

// another example
UIView.animate(withDuration: 2.0) { [weak self] in
  guard let strongSelf = self else { return }
  strongSelf.alpha = 1.0
}
```

### 懒加载

```swift
lazy var locationManager = makeLocationManager()

private func makeLocationManager() -> CLLocationManager {
  let manager = CLLocationManager()
  manager.desiredAccuracy = kCLLocationAccuracyBest
  manager.delegate = self
  manager.requestAlwaysAuthorization()
  return manager
}
```

**Notes:**
  - `[unowned self]` 这里不会循环引用


### 类型推断

**推荐**:
```swift
let message = "Click the button"
let currentBounds = computeViewBounds()
var names = ["Mic", "Sam", "Christine"]
let maximumWidth: CGFloat = 106.5
```

**不允许**:
```swift
let message: String = "Click the button"
let currentBounds: CGRect = computeViewBounds()
var names = [String]()
```

**推荐**:
```swift
var names: [String] = []
var lookup: [String: Int] = [:]
```

**不允许**:
```swift
var names = [String]()
var lookup = [String: Int]()
```

### 语法糖

最好使用类型声明的快捷方式版本，而不要使用完整的泛型语法。

**推荐**:
```swift
var deviceModels: [String]
var employees: [Int: String]
var faxNumber: Int?
```

**不允许**:
```swift
var deviceModels: Array<String>
var employees: Dictionary<Int, String>
var faxNumber: Optional<Int>
```

## 函数 vs 方法

**推荐**
```swift
let sorted = items.mergeSorted()  // easily discoverable
rocket.launch()  // acts on the model
```

**不允许**
```swift
let sorted = mergeSort(items)  // hard to discover
launch(&rocket)
```

**Free Function Exceptions**
```swift
let tuples = zip(a, b)  // feels natural as a free function (symmetry)
let value = max(x, y, z)  // another free function that feels natural
```

## 内存管理

延迟对象生命周期 `[weak self]` , `guard let self = self else { return }` 

优先使用 `[weak self]` 再使用 `[unowned self]` 

**推荐**
```swift
resource.request().onComplete { [weak self] response in
  guard let self = self else {
    return
  }
  let model = self.updateModel(response)
  self.updateUI(model)
}
```

**不允许**
```swift
// might crash if self is released before response returns
resource.request().onComplete { [unowned self] response in
  let model = self.updateModel(response)
  self.updateUI(model)
}
```

**不允许**
```swift
// deallocate could happen between updating the model and updating UI
resource.request().onComplete { [weak self] response in
  let model = self?.updateModel(response)
  self?.updateUI(model)
}
```

## 访问控制

优先使用 `private` 和 `fileprivate` 

少用 `open`, `public`

**推荐**:
```swift
private let message = "Great Scott!"

class TimeMachine {  
  private dynamic lazy var fluxCapacitor = FluxCapacitor()
}
```

**不允许**:
```swift
fileprivate let message = "Great Scott!"

class TimeMachine {  
  lazy dynamic private var fluxCapacitor = FluxCapacitor()
}
```

## Control Flow

Prefer the `for-in` style of `for` loop over the `while-condition-increment` style.

**推荐**:
```swift
for _ in 0..<3 {
  print("Hello three times")
}

for (index, person) in attendeeList.enumerated() {
  print("\(person) is at position #\(index)")
}

for index in stride(from: 0, to: items.count, by: 2) {
  print(index)
}

for index in (0...3).reversed() {
  print(index)
}
```

**不允许**:
```swift
var i = 0
while i < 3 {
  print("Hello three times")
  i += 1
}


var i = 0
while i < attendeeList.count {
  let person = attendeeList[i]
  print("\(person) is at position #\(i)")
  i += 1
}
```

### 三元运算符

**推荐**:

```swift
let value = 5
result = value != 0 ? x : y

let isHorizontal = true
result = isHorizontal ? x : y
```

**不允许**:

```swift
result = a > b ? x = c > d ? c : d : y
```

### guard vs if let

**推荐**:
```swift
func computeFFT(context: Context?, inputData: InputData?) throws -> Frequencies {
  guard let context = context else {
    throw FFTError.noContext
  }
  guard let inputData = inputData else {
    throw FFTError.noInputData
  }

  // use context and input to compute the frequencies
  return frequencies
}
```

**不允许**:
```swift
func computeFFT(context: Context?, inputData: InputData?) throws -> Frequencies {
  if let context = context {
    if let inputData = inputData {
      // use context and input to compute the frequencies

      return frequencies
    } else {
      throw FFTError.noInputData
    }
  } else {
    throw FFTError.noContext
  }
}
```

推荐用 `guard` or `if let` 少用 `if else`

**推荐**:
```swift
guard 
  let number1 = number1,
  let number2 = number2,
  let number3 = number3 
else {
  fatalError("impossible")
}
// do something with numbers
```

**不允许**:
```swift
if let number1 = number1 {
  if let number2 = number2 {
    if let number3 = number3 {
      // do something with numbers
    } else {
      fatalError("impossible")
    }
  } else {
    fatalError("impossible")
  }
} else {
  fatalError("impossible")
}
```

### 分号

句末不需要分号

**推荐**:
```swift
let swift = "not a scripting language"
```

**不允许**:
```swift
let swift = "not a scripting language";
```

**NOTE**: Swift is very different from JavaScript, where omitting semicolons is [generally considered unsafe](http://stackoverflow.com/questions/444080/do-you-recommend-using-semicolons-after-every-statement-in-javascript)

### 括号

**推荐**:
```swift
if name == "Hello" {
  print("World")
}
```

**不允许**:
```swift
if (name == "Hello") {
  print("World")
}
```

In larger expressions, optional parentheses can sometimes make code read more clearly.

**推荐**:
```swift
let playerMark = (player == current ? "X" : "O")
```

## 多行String

**推荐**:

```swift
let message = """
  You cannot charge the flux \
  capacitor with a 9V battery.
  You must use a super-charger \
  which costs 10 credits. You currently \
  have \(credits) credits available.
  """
```

**不允许**:

```swift
let message = """You cannot charge the flux \
  capacitor with a 9V battery.
  You must use a super-charger \
  which costs 10 credits. You currently \
  have \(credits) credits available.
  """
```

**不允许**:

```swift
let message = "You cannot charge the flux " +
  "capacitor with a 9V battery.\n" +
  "You must use a super-charger " +
  "which costs 10 credits. You currently " +
  "have \(credits) credits available."
```

+ 字符串拼接不要用 `+`   

```swift
var desc = "your name \(name) and age \(age) "
```


## References

* [The Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
* [The Swift Programming Language](https://developer.apple.com/library/prerelease/ios/documentation/swift/conceptual/swift_programming_language/index.html)
* [Using Swift with Cocoa and Objective-C](https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/BuildingCocoaApps/index.html)
* [Swift Standard Library Reference](https://developer.apple.com/library/prerelease/ios/documentation/General/Reference/SwiftStandardLibraryReference/index.html)
