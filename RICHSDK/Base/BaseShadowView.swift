//
//  BaseShadowView.swift
//  RICHSDK
//
//  Created by Apple on 25/4/21.
//

import UIKit

open class BaseShadowView: UIView {
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let shadowPath = UIBezierPath(rect: bounds)
        layer.masksToBounds = false
        layer.shadowPath = shadowPath.cgPath
    }
}
