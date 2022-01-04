//
//  BaseCornerView.swift
//  RICHSDK
//
//  Created by Apple on 24/4/21.
//

import UIKit

open class BaseCornerView: UIView {
    @IBInspectable var cornerRadii: CGSize = .zero
    @IBInspectable var borderWidth: CGFloat = 0
    private var corners: UIRectCorner = .allCorners
    private var border: BorderType = .none
    /// 指定位置切圆角，在awakeFromNib或initFrame中调用
    ///
    /// - Parameters:
    ///   - corners: 需要切的角
    ///   - cornerRadii: 圆角半径
    ///   - border: 圆角边框类型 BorderType，默认不显示边框
    public func setCorner(corners: UIRectCorner, cornerRadii: CGSize, border: BorderType = .none) {
        self.corners = corners
        self.cornerRadii = cornerRadii
        self.border = border
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        var type: BorderType = .none
        if let borderColor = borderColor, borderWidth != 0 {
            type = .solid(width: borderWidth, color: borderColor)
        }
        bezierCorner(corners: corners, cornerRadii: cornerRadii, border: type)
    }
}
