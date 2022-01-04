//
//  BaseTextField.swift
//  RICHSDK
//
//  Created by Apple on 28/4/21.
//

import UIKit

/// 带placeholder的UITextView
open class BaseTextField: UITextField {
    @IBInspectable public var maxlength: UInt = 0

    override open func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextField.textDidChangeNotification, object: nil)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: UITextField.textDidChangeNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override public var text: String! {
        didSet {
            super.text = text
            textChanged()
        }
    }

    @objc func textChanged() {
        if maxlength > 0 && text.count > maxlength {
            self.text = String(text.prefix(Int(maxlength)))
        }
    }

    public var deleteBackwardBlcok: ((BaseTextField) -> Void)?

    override public func deleteBackward() {
        super.deleteBackward()
        deleteBackwardBlcok?(self)
    }
}
