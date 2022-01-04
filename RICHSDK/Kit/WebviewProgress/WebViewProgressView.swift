//
//  WebViewProgressView.swift
//  richdemo
//
//  Created by Apple on 3/3/21.
//

import UIKit

public class WebViewProgressView: UIView {
    var progress: Float = 0.0
    var progressBarView: UIView?
    var barAnimationDuration: TimeInterval?
    var fadeAnimationDuration: TimeInterval?
    var fadeOutDelay: TimeInterval?

    // MARK: Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    // MARK: Private Method
    private func configureViews() {
        self.isUserInteractionEnabled = false
        self.autoresizingMask = .flexibleWidth
        progressBarView = UIView(frame: self.bounds)
        progressBarView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        var tintColor: UIColor = .init(red: 22 / 255, green: 126 / 255, blue: 251 / 255, alpha: 1.0)
        if let color = UIApplication.shared.delegate?.window??.tintColor {
            tintColor = color
        }
        progressBarView?.backgroundColor = tintColor
        self.addSubview(progressBarView ?? UIView())

        barAnimationDuration = 0.1
        fadeAnimationDuration = 0.27
        fadeOutDelay = 0.1
    }

    // MARK: Public Method
    public func setProgress(_ progress: Float, animated: Bool = false) {
        let isGrowing = progress > 0.0
        if let barAnimationDuration = barAnimationDuration {
            UIView.animate(withDuration: (isGrowing && animated) ? barAnimationDuration : 0.0,
                           delay: 0.0, options: UIView.AnimationOptions(), animations: {
                var frame = self.progressBarView?.frame
                frame?.size.width = CGFloat(progress) * self.bounds.size.width
                self.progressBarView?.frame = frame ?? .zero
            }, completion: nil)
        }

        guard let fadeAnimationDuration = fadeAnimationDuration else { return }
        if progress >= 1.0 {
            guard let fadeOutDelay = fadeOutDelay else { return }
            UIView.animate(withDuration: animated ? fadeAnimationDuration : 0.0,
                           delay: fadeOutDelay, options: UIView.AnimationOptions(), animations: {
                self.progressBarView?.alpha = 0.0
                }, completion: { _ in
                    var frame = self.progressBarView?.frame
                    frame?.size.width = 0
                    self.progressBarView?.frame = frame ?? .zero
            })
        } else {
            UIView.animate(withDuration: animated ? fadeAnimationDuration : 0.0, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                self.progressBarView?.alpha = 1.0
            }, completion: nil)
        }
    }
}
