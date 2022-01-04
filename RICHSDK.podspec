Pod::Spec.new do |s|

  s.name         = "RICHSDK"
  s.version      = "0.0.1"
  s.summary      = "项目基础依赖库"

  s.description  = <<-DESC
                     app项目基础依赖库
                   * 网络模块Api
                   * 路由模块PageRouter
                   * Toast
                   * 系统、UI配置
                   * UI组件库
                   * 语言本地化
                   * 数据存储UserDefaults
                   * sqlite/iclould
                   DESC

  s.homepage     = "https://github.com/lyf-yuanyou/RICHSDK"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors      = { "rich-app" => "65458@rich.com" }

  s.swift_version = "5.0"

  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.13"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "11.0"

  s.source       = { :git => "https://github.com/lyf-yuanyou/RICHSDK.git", :tag => s.version }
  s.source_files = ["RICHSDK/**/*.swift"]
  s.resources = [
    "RICHSDK/Resources/**/*.json",
    "RICHSDK/Resources/**/*.gif",
    'RICHSDK/Resources/*.xcassets',
    'RICHSDK/*.lproj',
    'RICHSDK/**/*.xib',
    'RICHSDK/**/*.storyboard'
  ]
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }

  s.requires_arc = true
  s.frameworks = "Foundation", "UIKit"
  
  s.dependency 'Kingfisher', '~> 6.0'
  s.dependency 'SnapKit', '~> 5.0.0'
  s.dependency 'Alamofire', '~> 5.0'
  s.dependency 'HandyJSON', '~> 5.0.2'
  s.dependency 'Alamofire', '~> 5.0'
  s.dependency 'MJRefresh', '~> 3.5.0'
  s.dependency 'Then', '~> 2.7.0'
  s.dependency 'IQKeyboardManagerSwift', '~> 6.5.6'
  s.dependency 'FDFullscreenPopGesture', '1.1'
  s.dependency 'KeychainAccess', '~>4.2.2'

end
