//
//  UIDevice+ModelName.swift
//  richapp
//
//  Created by SDS on 2021/5/20.
//

import UIKit

public extension UIDevice {
    /// 设备ip地址
    static var deviceIp: String {
        var addressIP: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                let flags = Int32(ptr!.pointee.ifa_flags)
                var addr = ptr!.pointee.ifa_addr.pointee
                if (flags & (IFF_UP | IFF_RUNNING | IFF_LOOPBACK)) == (IFF_UP | IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0 {
                            if let address = String(validatingUTF8: hostname) {
                                addressIP = address
                            }
                        }
                    }
                }
                ptr = ptr!.pointee.ifa_next
            }
            freeifaddrs(ifaddr)
        }
        return addressIP ?? "192.168.1.1"
    }

    /// 设备名称
    static var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case"iPod5,1":
            return"iPod Touch 5"
        case"iPod7,1":
            return"iPod Touch 6"
        case"iPhone3,1", "iPhone3,2", "iPhone3,3":
            return"iPhone4"
        case"iPhone4,1":
            return"iPhone4s"
        case"iPhone5,1", "iPhone5,2":
            return"iPhone5"
        case"iPhone5,3", "iPhone5,4":
            return"iPhone5c"
        case"iPhone6,1", "iPhone6,2":
            return"iPhone5s"
        case"iPhone7,2":
            return"iPhone6"
        case"iPhone7,1":
            return"iPhone6 Plus"
        case"iPhone8,1":
            return"iPhone6s"
        case"iPhone8,2":
            return"iPhone6s Plus"
        case"iPhone8,4":
            return"iPhoneSE"
        case"iPhone9,1", "iPhone9,3":
            return"iPhone7"
        case"iPhone9,2", "iPhone9,4":
            return"iPhone7 Plus"
        case"iPhone10,1", "iPhone10,4":
            return"iPhone8"
        case"iPhone10,5", "iPhone10,2":
            return"iPhone8 Plus"
        case"iPhone10,3", "iPhone10,6":
            return"iPhoneX"
        case"iPhone11,2":
            return"iPhoneXS"
        case"iPhone11,6":
            return"iPhoneXS MAX"
        case"iPhone11,8":
            return"iPhoneXR"
        case"iPhone12,1":
            return"iPhone11"
        case"iPhone12,3":
            return"iPhone11 ProMax"
        case"iPhone12,5":
            return"iPhone11 Pro"

        case"iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return"iPad 2"
        case"iPad3,1", "iPad3,2", "iPad3,3":
            return"iPad 3"
        case"iPad3,4", "iPad3,5", "iPad3,6":
            return"iPad 4"
        case"iPad4,1", "iPad4,2", "iPad4,3":
            return"iPad Air"
        case"iPad5,3", "iPad5,4":
            return"iPad Air 2"
        case"iPad2,5", "iPad2,6", "iPad2,7":
            return"iPad Mini"
        case"iPad4,4", "iPad4,5", "iPad4,6":
            return"iPad Mini 2"
        case"iPad4,7", "iPad4,8", "iPad4,9":
            return"iPad Mini 3"
        case"iPad5,1", "iPad5,2":
            return"iPad Mini 4"
        case"iPad6,7", "iPad6,8":
            return"iPad Pro"

        case"AppleTV5,3":
            return"Apple TV"
        case"i386", "x86_64":
            return"Simulator"

        default:
            return identifier
        }
    }
}
