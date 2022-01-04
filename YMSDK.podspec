Pod::Spec.new do |s|

  s.name         = "YMSDK"
  s.version      = "0.0.8"
  s.summary      = "YM系app项目基础依赖库"

  s.description  = <<-DESC
                     YM系app项目基础依赖库
                   * 网络模块Api
                   * 路由模块PageRouter
                   * Toast
                   * 系统、UI配置
                   * UI组件库
                   * 语言本地化
                   * 数据存储UserDefaults
                   * sqlite/iclould
                   DESC

  s.homepage     = "http://git.yostata.xyz/ios/YMSDK"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors      = { "kok-app" => "j02358@kok.com" }

  s.swift_version = "5.0"

  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.13"
  s.watchos.deployment_target = "3.0"
  s.tvos.deployment_target = "11.0"

  s.source       = { :git => "http://git.yostata.xyz/ios/YMSDK.git", :tag => s.version }
  s.source_files = ["YMSDK/**/*.swift"]
  s.resources = [
    "YMSDK/Resources/**/*.json",
    "YMSDK/Resources/**/*.gif",
    'YMSDK/Resources/*.xcassets',
    'YMSDK/*.lproj',
    'YMSDK/**/*.xib',
    'YMSDK/**/*.storyboard'
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
