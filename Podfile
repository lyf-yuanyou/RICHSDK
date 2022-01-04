platform :ios, '11.0'

workspace 'RICHSDK.xcworkspace'
project 'RICHSDK.xcodeproj'
project 'Demo/richsdkdemo.xcodeproj'

use_frameworks!
pod 'SnapKit', '~> 5.0.0'
pod 'Alamofire', '~> 5.0'
pod 'HandyJSON', '~> 5.0.2'
pod 'Kingfisher', '~> 6.0'
pod 'Then', '~> 2.7.0'
#pod 'MJRefresh', :git => 'http://git.yostata.xyz/ios/YMRefresh.git'
pod 'MJRefresh', :path => '../YMRefresh'
pod 'IQKeyboardManagerSwift', '~> 6.5.6'
pod 'FDFullscreenPopGesture', '1.1'
pod 'KeychainAccess', '~>4.2.2'

target 'RICHSDK' do
  project 'RICHSDK.xcodeproj'
  pod 'SwiftLint', :configurations => ['Debug']

end

target 'richsdkdemo' do
  project 'Demo/richsdkdemo.xcodeproj'

end
