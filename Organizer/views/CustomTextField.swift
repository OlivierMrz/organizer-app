//
//  CustomTextField.swift
//  Organizer
//
//  Created by Olivier Miserez on 15/01/2020.
//  Copyright © 2020 Olivier Miserez. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    func setup(placeHolder: String) {
        attributedPlaceholder =
        NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: Color.midGray as Any])
    }

    func setup() {
        backgroundColor = Color.lightGray
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 32))
        leftViewMode = .always
        layer.cornerRadius = CornerRadius.xSmall
        layer.masksToBounds = true
        clearButtonMode = .whileEditing
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
