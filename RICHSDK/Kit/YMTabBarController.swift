//
//  YMTabBarController.swift
//  RICHSDK
//
//  Created by admin on 2021/3/25.
//

import Then
import UIKit

public class YMTabBar: UITabBar {
    private var shapeLayer: CALayer?

    var midBtn: UIButton?

    var selectedMidBtn : ((_ index: Int) -> Void)?

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        addShape()

        if let cnt = items?.count {
            var midIndex = 0
            if cnt == 3 {
                midIndex = 1
            } else if cnt == 5 {
                midIndex = 2
            } else {
                return
            }

            items![midIndex].imageInsets = UIEdgeInsets(top: -13, left: 0, bottom: 13, right: 0)

            if midBtn != nil {
                midBtn!.removeFromSuperview()
            }
            let btnFrame = CGRect(x: UIDevice.width / 2.0 - 25.0, y: -20, width: 50, height: 50)
            midBtn = UIButton(frame: btnFrame).then {
                self.addSubview($0)
                $0.backgroundColor = .clear
                $0.addTarget(self, action: #selector(onMidBtnTapped), for: .touchUpInside)
            }
        }
    }

    @objc func onMidBtnTapped() {
        if let cnt = items?.count {
            if cnt == 3 {
                selectedMidBtn?(1)
            } else if cnt == 5 {
                selectedMidBtn?(2)
            } else {
                return
            }
        }
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()

        let viColor = UIColor(red: 67 / 255, green: 16 / 255, blue: 0, alpha: 0.15)
        let cnColor = UIColor.hex("#F3CCC1")
        shapeLayer.strokeColor = Localized.language == .vietnam ? viColor.cgColor : cnColor.cgColor

        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.5
        shapeLayer.shadowOffset = CGSize(width: 0, height: -2)
        shapeLayer.shadowRadius = 4
        shapeLayer.shadowColor = UIColor.hex("#DBDBDB").cgColor
        shapeLayer.shadowOpacity = 0.26

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let height: CGFloat = 86
        let path = UIBezierPath()
        let centerWidth = frame.width / 2
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - 45 ), y: 0))

        path.addCurve(to: CGPoint(x: centerWidth, y: height - 55),
                      controlPoint1: CGPoint(x: (centerWidth - 16), y: 5),
                      controlPoint2: CGPoint(x: centerWidth - 31, y: height - 58))

        path.addCurve(to: CGPoint(x: (centerWidth + 45 ), y: 0),
                      controlPoint1: CGPoint(x: centerWidth + 31, y: height - 58),
                      controlPoint2: CGPoint(x: (centerWidth + 16), y: 5))

        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        return path.cgPath
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else {
            return nil
        }

        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else {
                continue
            }
            return result
        }
        return nil
    }
}

open class YMTabBarController: UITabBarController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        let myTabBar = YMTabBar(frame: tabBar.frame)
        setValue(myTabBar, forKey: "tabBar")
        myTabBar.selectedMidBtn = { index in
            self.selectedIndex = index
        }
    }
}
