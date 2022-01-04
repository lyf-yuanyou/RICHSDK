//
//  BaseTextView.swift
//  RICHSDK
//
//  Created by Apple on 26/4/21.
//

import UIKit

/// 带placeholder的UITextView
public class BaseTextView: UITextView {
    @IBInspectable public var placeholder: String = ""
    @IBInspectable public var placeholderColor: UIColor = .lightGray
    @IBInspectable public var maxlength: UInt = 0
    private weak var placeHolderLabel: UILabel?

    override public func draw(_ rect: CGRect) {
        if !placeholder.isEmpty {
            if placeHolderLabel == nil {
                let label = UILabel(frame: CGRect(x: 8, y: 8, width: bounds.width - 16, height: 20))
                label.lineBreakMode = .byWordWrapping
                label.numberOfLines = 0
                label.font = font
                label.backgroundColor = .clear
                label.textColor = placeholderColor
                label.alpha = 0
                label.tag = 999
                addSubview(label)
                placeHolderLabel = label
            }
            placeHolderLabel!.text = placeholder.localized()
            placeHolderLabel!.sizeToFit()
            sendSubviewToBack(placeHolderLabel!)
        }
        if text.isEmpty, !placeholder.isEmpty {
            placeHolderLabel?.alpha = 1
        }
        super.draw(rect)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextView.textDidChangeNotification, object: nil)
    }

    deinit {
        placeHolderLabel?.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }

    override public var text: String! {
        didSet {
            super.text = text
            textChanged()
        }
    }

    @objc func textChanged() {
        if placeholder.isEmpty {
            return
        }
        UIView.animate(withDuration: 0.25) {
            self.placeHolderLabel?.alpha = self.text.isEmpty ? 1 : 0
        }
        if maxlength > 0 && text.count > maxlength {
            self.text = String(text.prefix(Int(maxlength)))
        }
    }
}
