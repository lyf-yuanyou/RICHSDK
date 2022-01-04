//
//  UIImage+extion.swift
//  RICHSDK
//
//  Created by Apple on 20/3/21.
//

import Photos
import UIKit

// MARK: - UIImage
public extension UIImage {
    /// 压缩图片到指定大小 bytes
    ///
    /// - Parameter maxLength: bytes
    /// - Returns: Data
    func compressQuality(maxLength: Int) -> Data {
        var compression: CGFloat = 1
        var data = self.jpegData(compressionQuality: compression)!
        if data.count < maxLength {
            return data
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = self.jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            }
        }
        return data
    }

    /// 压缩图片到指定宽度
    ///
    /// - Parameter width: width
    /// - Returns: UIImage
    func scaleImage(width: CGFloat) -> UIImage {
        if self.size.width < width {
            return self
        }
        let hight = width / self.size.width * self.size.height
        let rect = CGRect(x: 0, y: 0, width: width, height: hight)
        // 开启上下文
        UIGraphicsBeginImageContext(rect.size)
        // 将图片渲染到图片上下文
        self.draw(in: rect)
        // 获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        // 关闭图片上下文
        UIGraphicsEndImageContext()
        return image
    }

    /// 将图片缩放到指定的size
    /// - Parameter size: 目标尺寸
    /// - Returns: 返回UIImage
    func scaleToSize(size: CGSize) -> UIImage {
        // 创建一个bitmap的context
        // 并把它设置成为当前正在使用的context
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 从当前context中创建一个改变大小后的图片
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        // 使当前的context出堆栈
        UIGraphicsEndImageContext()
        // 返回新的改变大小后的图片
        return scaledImage ?? UIImage()
    }

    /// 裁剪带边框的图片 可设置圆角 边框颜色
    /// - Parameters:
    ///   - rect: rect
    ///   - radious: 圆角
    ///   - borderW: 边框宽度
    ///   - borderColor: 边框颜色
    /// - Returns: 返回UIImage
    func clipImageRadious(rect: CGRect, radious: CGFloat, borderW: CGFloat, borderColor: UIColor) -> UIImage {
        // 1、开启上下文
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // 2、设置边框
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radious)
        borderColor.setFill()
        path.fill()
        // 3、设置裁剪区域
        let clipPath = UIBezierPath(roundedRect: CGRect(x: rect.origin.x + borderW,
                                                        y: rect.origin.x + borderW,
                                                        width: rect.size.width - borderW * 2,
                                                        height: rect.size.height - borderW * 2),
                                    cornerRadius: radious)
        clipPath.addClip()
        // 4、绘制图片
        draw(at: CGPoint(x: 0, y: 0))
        // 5、获取新图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 6、关闭上下文
        UIGraphicsEndImageContext()
        // 7、返回新图片
        return newImage ?? UIImage()
    }

    /// 给图片添加水印
    /// - Parameters:
    ///   - waterImage: 水印image
    ///   - rect: 指定rect
    /// - Returns: 返回UIImage
    func addWaterImage(waterImage: UIImage, rect: CGRect) -> UIImage {
        // 1.开启上下文
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // 2.绘制背景图片
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        // 3.绘制水印图片到当前上下文
        waterImage.draw(in: rect)
        // 4.从上下文中获取新图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 5.关闭图形上下文
        UIGraphicsEndImageContext()
        // 6.返回图片
        return newImage ?? UIImage()
    }

    /// 将UIImage保存到相册
    /// - Parameters:
    ///   - successBlock: 成功回调
    ///   - errorBlock: 失败回调
    func saveToPhotoLibrary(successBlock: @escaping () -> Void, errorBlock: @escaping (Error) -> Void) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
        // 用户拒绝当前应用访问相册,提醒用户打开访问开关
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                PopAlertView.showTipAlert(obj: PopAlertObj(title: "提示".localized(),
                                                           subtitle: "您拒绝了访问相册，请到手机隐私设置".localized(),
                                                           confirmText: "确定".localized()))
            }
        case .restricted:
        // 家长控制,不允许访问
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                PopAlertView.showTipAlert(obj: PopAlertObj(title: "提示".localized(),
                                                           subtitle: "家长控制不允许访问相册".localized(),
                                                           confirmText: "确定".localized()))
            }
        case .notDetermined:
        // 用户还没有做出选择
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    // 允许
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.saveToAssets(successBlock: successBlock, errorBlock: errorBlock)
                    }
                } else {
                    // 拒绝
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        ToastUtil.showMessage("保存失败".localized())
                    }
                }
            }
        case .authorized:
        // 用户允许当前应用访问相册
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.saveToAssets(successBlock: successBlock, errorBlock: errorBlock)
            }
        default:
            print("未知状态")
        }
    }

    /// 将image保存到相册，此方法仅实现了保存图片功能，没有做权限的判断，如要实现完整功能，请使用saveToPhotoLibrary中保存图片方法
    private func saveToAssets(successBlock: @escaping () -> Void, errorBlock: @escaping (Error) -> Void) {
        ToastUtil.showLoading()
        PHPhotoLibrary.shared().performChanges {
            // 写入图片到相册
            _ = PHAssetChangeRequest.creationRequestForAsset(from: self)
        } completionHandler: { _, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ToastUtil.hide()
                error == nil ? successBlock() : errorBlock(error!)
            }
        }
    }
}
